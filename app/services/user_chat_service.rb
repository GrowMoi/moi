class UserChatService
  def initialize(sender:)
    @sender = sender
  end

  def send_message(chat_params)
    UserChat.create(
      sender_id: @sender.id,
      receiver_id: chat_params[:receiver_id],
      message: chat_params[:message]
    )
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
