class User < ActiveRecord::Base
  module UserAchievements

    def assign_achievements
      new_achievements = []
      achievements = AdminAchievement.all
      my_achievements = self.my_achievements
      no_achievements = achievements.reject{ |x| my_achievements.include? x }
      no_achievements.each do |achievement|
        if achievement.user_win_achievement?(self)
          new_achievements << UserAdminAchievement.create!(user_id: self.id, admin_achievement_id: achievement.id)
          notify_tutors(self, new_achievements)
        end
      end
      new_achievements
    end

    def reach_super_event
      completed = false
      if self.super_event_completed?
        notify_user_and_admin_super_event_completed
        completed = true
      end
    end

    def notify_client_got_item_to_tutors(notification_data)
      tutor_ids = get_tutor_ids(self)
      tutor_ids.each do |tutor_id|
        channel = "tutornotifications.#{tutor_id}"
        type = 'client_got_item'
        notify_by_channel(channel, notification_data, type)
      end
    end

    def notify_tutors(client, new_achievements)
      new_achievements.each do |achievement|
        data = {
          user_admin_achievement_id: achievement.id
        }
        notification = create_client_notification(client, data, "client_got_item")
        if notification
          notification_serialized = Api::ClientNotificationSerializer.new(
            notification,
            root: false
          )
          notify_client_got_item_to_tutors(notification_serialized)
        end
      end
    end

    def get_tutor_ids(client)
      UserTutor.where(user: client, status: :accepted)
               .pluck(:tutor_id)
    end

    #super event
    def notify_admin_super_event_completed(event)
      event.status = "completed"
      if event.save
        SuperEventMailer.notify_admin(
                              self,
                              event.event_achievement
                            ).deliver_now
      end
    end

    def notify_user_and_admin_super_event_completed
      user_event_achievement = self.user_event_achievements.last
      notify_admin_super_event_completed(user_event_achievement)
      notify_user_super_event_completed(user_event_achievement)
    end

    def notify_user_super_event_completed(event)
      data = {
        user_event_achievement_id: event.id,
        title: event.event_achievement.title,
        description: event.event_achievement.description,
        message: event.event_achievement.message
      }
      notification = create_client_notification(self,
                                                data,
                                                "client_completed_super_event"
                                              )
      if notification
        notification_serialized = Api::ClientNotificationSerializer.new(
          notification,
          root: false
        )
        channel = "usernotifications.#{self.id}"
        type = "new-notification"
        notify_by_channel(channel, notification_serialized, type)
      end
    end

    private

    def create_client_notification(client, data, type)
      notification = ClientNotification.new
      notification.client_id = client.id
      notification.data_type = type
      notification.data = data
      return notification.save ? notification : nil;
    end

    def notify_by_channel(channel, data, type)
      unless Rails.env.test?
        begin
          Pusher.trigger(channel, type, data)
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        else
          puts "PUSHER: Message sent successfully!"
          puts "PUSHER: #{data}"
        end
      end
    end
  end
end
