# == Schema Information
#
# Table name: user_tutor_recommendations
#
#  id                      :integer          not null, primary key
#  user_tutor_id           :integer          not null
#  tutor_recommendation_id :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class UserTutorRecommendation < ActiveRecord::Base
  belongs_to :user_tutor
  belongs_to :tutor_recommendation
end
