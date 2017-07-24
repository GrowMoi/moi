module Api
  class GenericNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :title,
        :description,
        :user_id,
        :links,
        :videos,
        :media

    def links
      link_urls = object.notification_links.map {|l| l[:link] }
      link_urls.compact
    end

    def videos
      video_urls = object.notification_videos.map {|v| v[:url] }
      video_urls.compact
    end

    def media
      media_urls = object.notification_medium.map {|m| m[:media] }
      media_urls.compact
    end
  end
end
