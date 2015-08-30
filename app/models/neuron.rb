# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#

class Neuron < ActiveRecord::Base
  has_paper_trail ignore: [:created_at, :id]

  STATES = %w(active inactive)

  STATES.map(&:to_sym).each do |state|
    scope state, -> {
      where(active: state == :active)
    }
  end

  scope :not_deleted, -> {
    where(deleted: false)
  }

  begin :relationships
    has_many :contents, dependent: :destroy
    belongs_to :parent, class: Neuron
  end

  accepts_nested_attributes_for :contents,
    allow_destroy: true,
    reject_if: ->(attributes) {
      attributes["description"].blank? && attributes["media"].blank?
    }

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
    validate :parent_is_not_child,
             if: ->{ parent_id.present? }
  end

  def to_s
    title
  end

  ##
  # builds a content for each level & kind
  def build_contents!
    Content::LEVELS.each do |level|
      Content::KINDS.each do |kind|
        unless contents_any?(level: level, kind: kind)
          contents.build(level: level, kind: kind)
        end
      end
    end
    self
  end

  ##
  # Saves and touches a version
  #
  # @yield [version] created version (if any)
  # @return [Boolean] if the record was saved or not
  def save_with_version(opts={})
    changed = changed? # if not already creating version
    contents_changed = contents_any?(changed?: true)
    transaction do
      save(opts).tap do |saved|
        if saved && !changed && contents_changed
          touch_with_version
        end

        # only if a version was created
        if changed || contents_changed
          yield versions.last if block_given?
        end
      end
    end
  end

  ##
  # validates parent is not a child or child of any of their
  # children
  def parent_is_not_child
    parent_is_child = false
    candidate = Neuron.find_by(id: parent_id)
    while candidate.present? && candidate.parent_id.present? && !parent_is_child
      parent_is_child = candidate.parent_id == id
      candidate = candidate.parent
    end
    errors.add(
      :parent,
      I18n.t(
        "activerecord.errors.messages.circular_parent",
        child: parent.to_s,
        parent: self.to_s
      )
    ) if parent_is_child
  end

  private

  def contents_any?(opts)
    contents.any? do |content|
      opts.all? do |key, val|
        content.send(key).eql?(val)
      end
    end
  end
end
