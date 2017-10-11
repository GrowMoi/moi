# == Schema Information
#
# Table name: content_learning_quizzes
#
#  id         :integer          not null, primary key
#  player_id  :integer          not null
#  questions  :json             not null
#  answers    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :content_learning_quiz do
    
  end

end
