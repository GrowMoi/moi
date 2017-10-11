module Api
  class LeaderboardSerializer < ActiveModel::Serializer
    attributes :id,
        :contents_learnt,
        :time_elapsed,
        :name,
        :email,
        :user_id

    def name
      object.user.name
    end

    def email
      object.user.email
    end

    def user_id
      object.user.id
    end
  end
end
