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
#

class ContentLearningTest < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
end
