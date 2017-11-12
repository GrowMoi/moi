# == Schema Information
#
# Table name: tutor_recommendations
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  tutor_achievement_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class TutorRecommendation < ActiveRecord::Base
  belongs_to :user
  validates :user_id,
            presence: true
  belongs_to :tutor_achievement
  has_many :user_tutor_recommendations,
           dependent: :destroy
  has_many :content_tutor_recommendations,
           dependent: :destroy
  has_many :client_approved_recommendations,
           dependent: :destroy
end
