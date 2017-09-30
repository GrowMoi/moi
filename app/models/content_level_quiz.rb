# == Schema Information
#
# Table name: content_level_quizzes
#
#  id            :integer          not null, primary key
#  content_id    :integer          not null
#  level_quiz_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ContentLevelQuiz < ActiveRecord::Base
  belongs_to :level_quiz
  belongs_to :content
end
