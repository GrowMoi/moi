# == Schema Information
#
# Table name: user_tutors
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  tutor_id           :integer          not null
#  status             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_date_request :datetime
#  end_date_request   :datetime
#

FactoryGirl.define do
  factory :user_tutor do
    user
    tutor { build :user }
  end
end
