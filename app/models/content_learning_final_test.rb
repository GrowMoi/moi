# == Schema Information
#
# Table name: content_learning_final_tests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  questions  :json             not null
#  answers    :json
#  approved   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :string           default("achievement")
#

class ContentLearningFinalTest < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
end
