# == Schema Information
#
# Table name: user_events
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  event_id   :integer          not null
#  completed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end
