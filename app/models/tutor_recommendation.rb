# == Schema Information
#
# Table name: tutor_recommendations
#
#  id                   :integer          not null, primary key
#  tutor_id             :integer          not null
#  tutor_achievement_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class TutorRecommendation < ActiveRecord::Base
  belongs_to :tutor, class_name: "User",
             foreign_key: "tutor_id"
  belongs_to :tutor_achievement
  has_many :content_tutor_recommendations,
           dependent: :destroy
  has_many :client_tutor_recommendations,
           dependent: :destroy
end
