module Api
  class RoomChatSerializer < ActiveModel::Serializer
    alias_method :current_user, :scope

    attributes :id,
        :type,
        :chat,
        :created_at

    def type
      'user_chat'
    end

    def chat
      user_chat = object.user_chats.last
      UserChatSerializer.new(
        user_chat,
        root: false,
        scope: current_user
      )
    end
  end
end
