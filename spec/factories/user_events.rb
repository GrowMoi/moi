# == Schema Information
#
# Table name: user_events
#
#  id                :integer          not null, primary key
#  user_id           :integer          not null
#  event_id          :integer          not null
#  completed         :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  contents          :json             default([]), is an Array
#  contents_learning :json             default([]), is an Array
#  expired           :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :user_event do
    
  end

end
