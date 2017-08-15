# == Schema Information
#
# Table name: notification_videos
#
#  id              :integer          not null, primary key
#  notification_id :integer          not null
#  url             :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class NotificationVideo < ActiveRecord::Base
  include Embeddable
  belongs_to :notification
  has_paper_trail ignore: [:created_at, :updated_at, :id]
end
