# == Schema Information
#
# Table name: content_instructions
#
#  id             :integer          not null, primary key
#  title          :string           not null
#  description    :string           not null
#  required_media :boolean
#  content_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :content_instruction do
    
  end

end
