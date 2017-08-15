module Api
  class AchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :description,
        :category,
        :settings
  end
end
