module Api
  class EventCompletedNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :title,
        :description,
        :type,
        :label,
        :media,
        :videos,
        :data_type,
        :created_at

    def title
      object.data['title']
    end

    def description
      object.data['description']
    end

    def created_at
      object.created_at
    end

    def media
      object.data['media']
    end

    def videos
      object.data['videos']
    end

    def type
      'super_event_notification'
    end

    def label
      NotificationService::NOTIFICATION_KEY
    end
  end
end