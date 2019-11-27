# == Schema Information
#
# Table name: content_questions
#
#  id         :integer          not null, primary key
#  question   :string
#  content_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :content_question do
    
  end

end
