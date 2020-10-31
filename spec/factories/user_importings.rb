# == Schema Information
#
# Table name: user_importings
#
#  id         :integer          not null, primary key
#  users      :json             default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  list       :string
#  file_name  :string
#

FactoryGirl.define do
  factory :user_importing do
    
  end

end
