module Api
  class UserChatSerializer < ResourceSerializer
    alias_method :current_user, :scope

    attributes :id,
               :sender_id,
               :receiver_id,
               :message,
               :created_at,
               :kind,
               :sender_user

    def kind
      if object.sender_id == current_user.id
        :outgoing
      else
        :incoming
      end
    end

    def sender_user
      UserSerializer.new(object.sender, root: false)
    end
  end
end