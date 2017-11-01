# == Schema Information
#
# Table name: content_reading_times
#
#  id         :integer          not null, primary key
#  content_id :integer          not null
#  user_id    :integer          not null
#  time       :float            not null
#  created_at :datetime         not null
#

FactoryGirl.define do
  factory :content_reading_time do
    content
    user
    time 1.5
  end
end
