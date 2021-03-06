# == Schema Information
#
# Table name: content_learning_tests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  questions  :json             not null
#  answers    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  completed  :boolean          default(FALSE)
#

class ContentLearningTest < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true

  scope :uncompleted, -> {
    where(completed: false)
  }
  scope :completed, -> {
    where(completed: true)
  }

  def is_successful_test?
    successful = false
    if self.answers
      successful = !(self.answers.any? { |answer| answer['correct'] == false })
    end
  end

end
