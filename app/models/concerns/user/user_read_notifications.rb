class User < ActiveRecord::Base
  module UserReadNotifications

    def create_read_notification(notification_id)
      read_notification = ReadNotification.new(user_id: self.id, notifications_id: notification_id)
      read_notification.save
    end
  end
end
