class UsersChatService
  class NotifyUserChatService
    def initialize(user_chat)
      @user_chat = user_chat
    end

    def notify!
      create_db_notifications!
      notify_via_pusher!
    end

    private

    def create_db_notifications!
      Notification.create!(
        user: @user_chat.receiver,
        title: "Nuevo chat",
        description: "Room Id: #{@user_chat.room_id}",
        data_type: "user_chat",
        client_id: @user_chat.sender_id
      )
    end

    def notify_via_pusher!
      return if Rails.env.test?
      notification_serialized = ::Api::UserChatSerializer.new(
        @user_chat,
        root: false,
        scope: @user_chat.receiver
      )
      user_channel_general = "userchatsnotifications.#{@user_chat.receiver_id}"
      Pusher.trigger(user_channel_general, 'newmessage', notification_serialized)
    end
  end
end
