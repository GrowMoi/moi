# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  title      :string
#  text       :text
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ActiveRecord::Base

  NUMBER_OF_LINKS = 3
  NUMBER_OF_VIDEOS = 1

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  acts_as_taggable_on :keywords

  after_create :delayed_notify_user!

  begin :relationships
    belongs_to :user

    has_many :notification_links,
              dependent: :destroy
    has_many :notification_videos,
              dependent: :destroy
    has_many :notification_medium,
              class_name: "NotificationMedia",
              dependent: :destroy
  end

  begin :nested_attributes

    accepts_nested_attributes_for :notification_medium,
      allow_destroy: true,
      reject_if: ->(attributes) {
        attributes["media"].blank?
      }

    accepts_nested_attributes_for :notification_links,
      reject_if: ->(attributes) {
        attributes["link"].blank?
      }

    accepts_nested_attributes_for :notification_videos,
      allow_destroy: true,
      reject_if: ->(attributes) {
        attributes["url"].blank?
      }
  end

  begin :scopes
    scope :with_media, -> {
      where("media_count > 0")
    }
  end

  def able_to_have_more_links?
    notification_links.length < NUMBER_OF_LINKS
  end

  def able_to_have_more_videos?
    notification_videos.length < NUMBER_OF_VIDEOS
  end


  def delayed_notify_user!
    unless Rails.env.test?
      if Rails.env.production?
        delay.send_pusher_notification!
      else
        send_pusher_notification!
      end
    end
  end

  def send_pusher_notification!
    formated = format_notification(self)
    user_channel_general = "usernotifications.general"
    Pusher.trigger(user_channel_general, 'new-notification', formated)
  end

  def format_notification(notification_created)
    json = notification_created.as_json(
      only: [
        :id,
        :title,
        :description,
        :user_id
      ],
      include: {
        notification_links: {
          only: :link
        },
        notification_medium: {
          only: :media
        },
        notification_videos: {
          only: [
            :url,
            :thumbnail
          ]
        }
      }
    )

    if json.key?("notification_links")
      link_urls = json["notification_links"].map {|l| l["link"] }
      json["links"] = link_urls.compact
      json.delete("notification_links")
    end
    if json.key?("notification_videos")
      video_urls = json["notification_videos"].map {|v| v["url"] }
      json["videos"] = video_urls.compact
      json.delete("notification_videos")
    end
    if json.key?("notification_medium")
      media_urls = json["notification_medium"].map {|m| m["media"]["url"] }
      json["media"] = media_urls.compact
      json.delete("notification_medium")
    end

    json
  end

end
