module Api
  class ChatsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:chat_service) {
      UserChatService.new(sender: current_user)
    }

    api :POST,
        "/chats",
        "send a chat message"
    param :receiver_id, Integer, required: true
    param :message, String, required: true
    def create
      chat_message = chat_service.send_message(chat_params)
      if chat_message.persisted?
        render json: chat_message
      else
        head :unprocessable_entity
      end
    end

    api :GET,
        "/chats/user/:user_id"
    param :user_id, Integer, required: true
    def show
      chat_messages = chat_service.retrieve_messages(
        receiver_id: params[:receiver_id]
      )
      render json: chat_messages, root: "user_chats"
    end

    private

    def chat_params
      params.permit(:receiver_id, :message)
    end
  end
end
