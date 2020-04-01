class UserChatService
  def initialize(sender:)
    @sender = sender
  end

  ##
  # @return [UserChat] instance of user chat
  #   with errors if there are any. you may
  #   call #persisted?
  def send_message(chat_params)
    user_chat = UserChat.create(
      sender_id: @sender.id,
      receiver_id: chat_params[:receiver_id],
      message: chat_params[:message]
    )
    if user_chat.persisted?
      notify_via_pusher!(user_chat)
    end
    user_chat
  end

  def notify_via_pusher!(user_chat)
    return if Rails.env.test?
    notification_serialized = ::Api::UserChatSerializer.new(
      user_chat,
      root: false,
      scope: user_chat.receiver
    )
    user_channel_general = "userchatsnotifications.#{user_chat.receiver_id}"
    Pusher.trigger(user_channel_general, 'newmessage', notification_serialized)
  end

  def retrieve_messages(receiver_id:)
    UserChat
      .where(
        "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
        receiver_id,
        @sender.id,
        @sender.id,
        receiver_id
      )
      .order(created_at: :asc)
      .limit(200)
  end
end
