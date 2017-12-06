module Api
  class AdminAchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :number,
        :description,
        :category
  end
end
