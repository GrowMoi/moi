# == Schema Information
#
# Table name: content_tutor_recommendations
#
#  id                      :integer          not null, primary key
#  content_id              :integer          not null
#  tutor_recommendation_id :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ContentTutorRecommendation < ActiveRecord::Base
  belongs_to :content
  belongs_to :tutor_recommendation
end
