module Api
  class LeaderboardSerializer < ActiveModel::Serializer
    attributes :id,
        :contents_learnt,
        :time_elapsed,
        :username,
        :email,
        :user_id

    def username
      object.user.username
    end

    def email
      object.user.email
    end

    def user_id
      object.user.id
    end
  end
end
