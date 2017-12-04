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

FactoryGirl.define do
  factory :client_tutor_recommendation do
    client { build :user}
    status "reached"
  end


end
