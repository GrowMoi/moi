# == Schema Information
#
# Table name: client_tutor_recommendations
#
#  id                      :integer          not null, primary key
#  client_id               :integer          not null
#  tutor_recommendation_id :integer          not null
#  status                  :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ClientTutorRecommendation < ActiveRecord::Base
  belongs_to :client,
             class_name: "User",
             foreign_key: "client_id"

  belongs_to :tutor_recommendation
  validates :status,
            presence: true
end
