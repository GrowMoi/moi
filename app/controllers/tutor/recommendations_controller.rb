module Tutor
  class RecommendationsController < TutorController::Base

    expose(:contents) {
      Content.where(approved: true)
    }

    expose(:tutor_achievements) {
      current_user.tutor_achievements
    }

    expose(:tutor_recommendation) {
      TutorRecommendation.new
    }

    expose(:tutor_achievement, attributes: :tutor_achievement_params)

    def new
      render
    end

    def create
      flash[:success] = I18n.t(
        "views.tutor.recommendations.recommendation_request.created",
        name: current_user.name
      )
      render :new
    end

    def new_achievement
      if tutor_achievement.save
        flash[:success] = I18n.t(
          "views.tutor.recommendations.achievement_request.created"
        )
        redirect_to :back
      else
        render nothing: true,
          status: :unprocessable_entity
      end
    end

    private

    def tutor_achievement_params
      params.require(:tutor_achievement).permit(
        :name,
        :description,
        :image)
    end

  end
end
