module Api
  class TutorRecommendationSerializer < ActiveModel::Serializer
    attributes :id,
               :tutor,
               :status,
               :achievement

    def tutor
      recommendation = TutorRecommendation.includes(:tutor).find(object.tutor_recommendation.id)
      TutorSerializer.new(recommendation.tutor, root: false)
    end

    def achievement
      recommendation = TutorRecommendation.includes(:tutor_achievement).find(object.tutor_recommendation.id)
      TutorAchievementSerializer.new(recommendation.tutor_achievement, root: false)
    end

    alias_method :current_user, :scope
  end
end
