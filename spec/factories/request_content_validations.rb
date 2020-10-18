# == Schema Information
#
# Table name: request_content_validations
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content_id :integer          not null
#  media      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean
#  text       :string
#

FactoryGirl.define do
  factory :request_content_validation do
    
  end

end
