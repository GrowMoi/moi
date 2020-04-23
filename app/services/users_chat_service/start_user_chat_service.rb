class UsersChatService
  class StartUserChatService
    SYS_MESSAGE = "start".freeze

    def initialize(sender:, receiver_id:)
      @sender = sender
      @receiver_id = receiver_id
    end

    def create!
      user_chat = UserChat.create(
        sender_id: @sender.id,
        receiver_id: @receiver_id,
        kind: :system,
        message: SYS_MESSAGE
      )
      NotifyUserChatService.new(user_chat).notify!
    end
  end
end
