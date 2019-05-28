module Api
  class EventCompletedNotificationSerializer < ActiveModel::Serializer
    attributes :id,
        :title,
        :description,
        :type,
        :label,
        :data_type,
        :created_at

    def title
      object.data['title']
    end

    def description
      object.data['message']
    end

    def created_at
      object.created_at
    end

    def type
      'super_event_notification'
    end

    def label
      NotificationService::NOTIFICATION_KEY
    end
  end
end