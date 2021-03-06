module Api
  class ClientNotificationRequestSerializer < ActiveModel::Serializer
    attributes :id,
               :user_id,
               :content_id,
               :approved,
               :username

    def username
      object.user.username
    end

    alias_method :current_user, :scope
  end
end