class ClientApprovedRecommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutor_recommendation
end
