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

FactoryGirl.define do
  factory :tutor_achievement do
    sequence(:name) { |n| "Achievement #{n}" }
    tutor { build :user }
  end
end
