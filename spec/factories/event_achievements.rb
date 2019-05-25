# == Schema Information
#
# Table name: event_achievements
#
#  id                   :integer          not null, primary key
#  user_achievement_ids :integer          default([]), is an Array
#  title                :string           not null
#  start_date           :datetime         not null
#  end_date             :datetime         not null
#  image                :string
#  message              :text
#  new_users            :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :string
#  inactive_image       :string
#

FactoryGirl.define do
  factory :event_achievement do
    
  end

end
