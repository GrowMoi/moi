module Api
  class UserChatSerializer < ResourceSerializer
    alias_method :current_user, :scope

    attributes :id,
               :sender_id,
               :receiver_id,
               :message,
               :created_at,
               :kind,
               :sender_user,
               :chat_with,
               :room_chat_id,
               :type

    def kind
      if object.sender_id == current_user.id
        :outgoing
      else
        :incoming
      end
    end

    def type
      object.kind
    end

    def  chat_with
      username = [object.receiver.username, object.sender.username] - [current_user.username]
      username[0]
    end

    def sender_user
      UserBasicInformationSerializer.new(object.sender, root: false)
    end
  end
end
