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
          if completed_super_event
            super_event = self.user_event_achievements.last
            super_event.status = "completed"
            super_event.save
          end
        end
      end
      new_achievements
    end

    def notify_client_got_item_to_tutors(notification_data)
      tutor_ids = get_tutor_ids(self)
      tutor_ids.each do |tutor_id|
        unless Rails.env.test?
          user_channel_general = "tutornotifications.#{tutor_id}"
          begin
            Pusher.trigger(user_channel_general, 'client_got_item', notification_data)
          rescue Exception => e
            puts e.message
            puts e.backtrace.inspect
          else
            puts "PUSHER: Message sent successfully!"
            puts "PUSHER: #{notification_data}"
          end
        end
      end
    end

    def create_client_got_item_notification(client, achievement)
      notification = ClientNotification.new
      notification.client_id = client.id
      notification.data_type = "client_got_item"
      notification.data = {
        user_admin_achievement_id: achievement.id
      }
      return notification.save ? notification : nil;
    end

    def notify_tutors(client, new_achievements)
      new_achievements.each do |achievement|
        notification = create_client_got_item_notification(client, achievement)
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

    def completed_super_event
      completed = false
      if super_event_is_valid_yet?
        ids_super_event = self.user_event_achievements.last.event_achievement.user_achievement_ids
        ids_user_achievements = self.user_admin_achievements.map(&:id)
        result = ids_achievements - ids_super_event #give a [] is not pending achievements
        completed = result.empty?
      end
    end

    def super_event_is_valid_yet?
      valid = false
      user_take_event = self.user_event_achievements.last
      if user_take_event
        super_event = user_take_event.event_achievement
        is_in_range = super_event.start_date < Time.now && super_event.end_date > Time.now
        valid = is_in_range && super_event.status == "taken"
      end
    end
  end
end
