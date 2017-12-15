module Api
  class UserAchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :number,
        :description,
        :active

    def name
      object.admin_achievement.name
    end

    def number
      object.admin_achievement.number
    end

    def description
      object.admin_achievement.description
    end
  end
end
