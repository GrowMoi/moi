module Api
  class UserAchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :number,
        :description,
        :active,
        :image,
        :inactive_image

    def name
      object.admin_achievement.name
    end

    def number
      object.admin_achievement.number
    end

    def description
      object.admin_achievement.description
    end

    def image
      object.admin_achievement.image ? object.admin_achievement.image.url : ''
    end

    def inactive_image
      object.admin_achievement.inactive_image ? object.admin_achievement.inactive_image.url : ''
    end
  end
end
