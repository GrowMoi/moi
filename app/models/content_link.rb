# == Schema Information
#
# Table name: content_links
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  link       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  language   :string           default("es")
#

class ContentLink < ActiveRecord::Base
  belongs_to :content
  validates :link, presence: true
  has_paper_trail ignore: [:created_at, :updated_at, :id]
  scope :with_language, ->(lang) { where(language: lang) }
end
