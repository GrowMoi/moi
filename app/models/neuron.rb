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

  begin :relationships
    has_many :contents, dependent: :destroy
    belongs_to :parent, class: Neuron
  end

  has_paper_trail ignore: [:created_at, :updated_at, :id]

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
  # builds a content for each level
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

  def versions_contents
    cv = PaperTrail::VersionAssociation.where(foreign_key_name: "neuron_id", foreign_key_id: self.id)
    PaperTrail::Version.where(id: cv.map(&:version_id))
  end
  # we need to merge current versions and content versions to use only one decorator and one each
  # def merged_versions
  #   self.versions.merge(self.versions_contents)
  # end

  private

  def contents_any?(opts)
    contents.any? do |content|
      opts.all? do |key, val|
        content.send(key).eql?(val)
      end
    end
  end
end
