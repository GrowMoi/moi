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

end
