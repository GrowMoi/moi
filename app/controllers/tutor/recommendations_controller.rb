module Tutor
  class RecommendationsController < TutorController::Base

    expose(:contents) {
      Content.where(approved: true)
    }

    expose(:tutor_achievements) {
      current_user.tutor_achievements.order(created_at: :desc)
    }

    expose :tutor_recommendation

    expose(:clients) {
      UserTutor.where(tutor: current_user, status: :accepted)
    }

    expose(:students_selected) {
      User.where(id: student_ids_params)
    }

    expose(:tutor_achievement, attributes: :tutor_achievement_params)

    def new
      render
    end

    def create
      tutor_recommendation.tutor = current_user
      achievement_id = tutor_recommendation_params[:tutor_achievement]

      if !achievement_id.empty?
        achievement = TutorAchievement.find(achievement_id)
        tutor_recommendation.tutor_achievement = achievement
      end

      if tutor_recommendation.save
        content_ids = tutor_recommendation_params[:content_tutor_recommendations]
        contents_to_recommendation(content_ids)
        flash[:success] = I18n.t(
          "views.tutor.recommendations.recommendation_request.created",
          clients: students_selected.pluck(:name).join(', ')
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end
      if request.xhr?
        render :js => "window.location = '#{request.referrer}'"
      else
        redirect_to :back
      end
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

    def tutor_recommendation_params
      params.require(:tutor_recommendation).permit(
        { content_tutor_recommendations: [] },
        :tutor_achievement,
        { students: [] }
      )
    end

    def student_ids_params
      tutor_recommendation_params[:students]
    end

    def contents_to_recommendation(content_ids)
      content_ids = content_ids.reject(&:blank?)
      students_ids = tutor_recommendation_params[:students]
      students_ids = students_ids.reject(&:blank?)
      if content_ids.any? && students_ids.any?
        content_ids.each do |id|
          content = Content.find(id)
          content_tutor_recommendation = ContentTutorRecommendation.new(
            tutor_recommendation: tutor_recommendation,
            content: content
          )
          if content_tutor_recommendation.save

            recommendation_to_client(students_ids, tutor_recommendation, content_ids)
          end
        end
      end
    end

    def recommendation_to_client (students_ids, recommendation, content_ids)
      students_ids.each do |user_id|
        student = User.find(user_id)
        TutorService::RecommendationsStatusUpdater.new(
          student,
          recommendation,
          content_ids
        ).perform
      end
    end
  end
end
