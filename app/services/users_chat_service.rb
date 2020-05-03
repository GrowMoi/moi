class UsersChatService
  def initialize(sender:)
    @sender = sender
  end

  ##
  # @return [UserChat] instance of user chat
  #   with errors if there are any. you may
  #   call #persisted?
  def send_message(chat_params)
    SendUserChatMessageService.create!(
      sender: @sender,
      chat_params: chat_params
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

  def start_chat!(receiver_id:, room_id:)
    StartUserChatService.new(
      sender: @sender,
      receiver_id: receiver_id,
      room_id: room_id
    ).create!
  end
end
