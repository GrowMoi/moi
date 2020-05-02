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
        message: @chat_params[:message],
        room_chat_id: @chat_params[:room_chat_id]
      )
      if @user_chat.persisted?
        NotifyUserChatService.new(@user_chat).notify!
      end
    end
  end
end
