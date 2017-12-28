module Tutor
  class DashboardController < TutorController::Base

    expose(:tutor_achievements) {
      current_user.tutor_achievements
    }

    expose(:tutor_achievement, attributes: :tutor_achievement_params)

    def achievements
      render json: {}
    end

    def index
      render
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
        :image
      )
    end

  end
end
