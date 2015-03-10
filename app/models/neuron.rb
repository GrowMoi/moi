# == Schema Information
#
# Table name: neurons
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Neuron < ActiveRecord::Base
  has_paper_trail ignore: [:created_at, :id]

  begin :relationships
    has_many :contents, dependent: :destroy
    belongs_to :parent, class: Neuron
  end

  accepts_nested_attributes_for :contents,
    allow_destroy: true,
    reject_if: ->(attributes) {
      attributes["description"].blank?
    }

  begin :validations
    validates :title, presence: true,
                      uniqueness: true
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
  # Saves and touches a version if `will_touch`
  # is set
  #
  # @return [Boolean] if the record was saved or not
  def save_with_version
    changed = changed? # if not already creating version
    contents_changed = contents_any?(changed?: true)
    transaction do
      save.tap do |saved|
        if saved && !changed && contents_changed
          touch_with_version
        end
      end
    end
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
