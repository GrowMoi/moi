# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  notifications_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ReadNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifications
end
