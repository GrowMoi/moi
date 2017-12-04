# == Schema Information
#
# Table name: tutor_achievements
#
#  id          :integer          not null, primary key
#  tutor_id    :integer          not null
#  name        :string           not null
#  description :text
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TutorAchievement < ActiveRecord::Base
  has_paper_trail ignore: [:created_at, :updated_at, :id]

  mount_uploader :image, ContentMediaUploader

  belongs_to :tutor, class_name: "User",
             foreign_key: "tutor_id"
  validates :name,
            presence: true
  has_many :tutor_recommendations
end
