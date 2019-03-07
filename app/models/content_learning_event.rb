# == Schema Information
#
# Table name: content_learning_events
#
#  id            :integer          not null, primary key
#  user_event_id :integer          not null
#  content_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ContentLearningEvent < ActiveRecord::Base
  belongs_to :user_event
  belongs_to :content
end
