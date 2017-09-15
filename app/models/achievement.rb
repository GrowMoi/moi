# == Schema Information
#
# Table name: achievements
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  label       :string           not null
#  description :text
#  image       :string
#  category    :string           not null
#  settings    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Achievement < ActiveRecord::Base

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  mount_uploader :image, ContentMediaUploader

  validates :name,
            presence: true
  validates :label,
            presence: true
  validates :category,
            presence: true
  validates :settings,
            presence: true
end
