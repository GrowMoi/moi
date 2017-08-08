# == Schema Information
#
# Table name: notification_media
#
#  id              :integer          not null, primary key
#  media           :string
#  notification_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class NotificationMedia < ActiveRecord::Base
  belongs_to :notification,
             counter_cache: :media_count

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  mount_uploader :media, ContentMediaUploader
end
