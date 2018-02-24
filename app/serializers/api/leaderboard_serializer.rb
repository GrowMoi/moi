module Api
  class LeaderboardSerializer < ActiveModel::Serializer
    attributes :id,
        :contents_learnt,
        :time_elapsed,
        :username,
        :email,
        :user_id

    def username
      object.user ? object.user.username : 'unknow'
    end

    def email
      object.user ? object.user.email : 'unknow'
    end

    def user_id
      object.user ? object.user.username : nil
    end
  end
end
