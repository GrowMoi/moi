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
  attr_accessor :content_id, :level, :kind, :description, :neuron_id
  begin :relationships
    has_many :contents, dependent: :destroy
    belongs_to :parent, class: Neuron
  end

  has_paper_trail :meta =>  {
                              content_id: :content_id,
                              kind: :kind,
                              description: :description,
                              level: :level,
                              neuron_id: :neuron_id,
                            }

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

  private

  def contents_any?(opts)
    contents.any? do |content|
      opts.all? do |key, val|
        content.send(key).eql?(val)
      end
    end
  end
end
