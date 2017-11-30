module Api
  class TutorAchievementSerializer < ActiveModel::Serializer
    attributes :id,
               :name,
               :description,
               :image_url
  end
end
