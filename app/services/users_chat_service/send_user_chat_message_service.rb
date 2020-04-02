class UsersChatService
  class SendUserChatMessageService
    class << self
      def create!(chat_params)
        service_instance = new(chat_params)
        service_instance.create!
        service_instance.user_chat
      end
    end

    attr_reader :user_chat

    def initialize(sender:, chat_params:)
      @sender = sender
      @chat_params = chat_params
    end

    def create!
      @user_chat = UserChat.create(
        sender_id: @sender.id,
        receiver_id: @chat_params[:receiver_id],
        message: @chat_params[:message]
      )
      if @user_chat.persisted?
        create_db_notifications!
        notify_via_pusher!
      end
    end

    private

    def create_db_notifications!
      Notification.create!(
        user: @user_chat.receiver,
        title: "Nuevo chat",
        description: "Chat con #{@user_chat.sender.to_s}",
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
