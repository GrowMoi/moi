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

require 'rails_helper'

RSpec.describe ContentLearningQuiz, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
