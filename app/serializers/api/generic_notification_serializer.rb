module Api
  class GenericNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :title,
        :description,
        :user_id,
        :videos,
        :media,
        :type,
        :tutor,
        :chat,
        :created_at

    def videos
      video_urls = object.notification_videos.map {|v| v[:url] }
      video_urls.compact
    end

    def media
      media_urls = object.notification_medium.map(&:media_url)
      media_urls.compact
    end

    def created_at
      object.created_at
    end

    def type
      object.data_type || 'generic'
    end

    def tutor
      if type != 'user_chat'
        TutorSerializer.new(object.user, root: false)
      end
    end

    def chat
      if type == 'user_chat'
        user_chat = UserChat.where(sender:  object.client, receiver: object.user).last
        UserChatSerializer.new(
          @ser_chat,
          root: false,
          scope: user_chat.receiver
        )
      end
    end
  end
end
