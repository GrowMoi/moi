module Api
  class ChatsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:chat_service) {
      UsersChatService.new(sender: current_user)
    }

    api :POST,
        "/chats",
        "send a chat message"
    param :receiver_id, Integer, required: true
    param :room_chat_id, Integer, required: true
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

    api :POST,
        "/chats/start/:receiver_id"
    param :receiver_id, Integer, required: true
    def start_chat
      room = RoomChat.where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)", 
              current_user.id, 
              params[:receiver_id],
              params[:receiver_id],
              current_user.id).last
      if room
        send_start_message(room)
      else
        new_room = RoomChat.new(sender: current_user, receiver_id: params[:receiver_id])
        new_room.save
        send_start_message(new_room)
      end
    end

    api :PUT,
        "/chats/leave/:room_id"
    param :room_id, Integer, required: true
    def leave_chat
      room = RoomChat.find(params[:room_id])
      if (room.sender_id == current_user.id)
        room.sender_leave = true;
        room.save
      else
        room.receiver_leave = true;
        room.save
      end
      render json: room
    end

    private

    def chat_params
      params.permit(:receiver_id, :message, :room_chat_id)
    end

    def send_start_message(room)
      chat_service.start_chat!(
        receiver_id: params[:receiver_id],
        room_id: room.id
      )
      render json: room
    end
  end
end
