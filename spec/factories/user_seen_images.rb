# == Schema Information
#
# Table name: user_seen_images
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  content_media_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :user_seen_image do
    
  end

end
