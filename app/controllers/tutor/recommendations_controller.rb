module Tutor
  class RecommendationsController < TutorController::Base

    expose(:contents) {
      Content.where(approved: true)
    }

    expose(:tutor_achievements) {
      current_user.tutor_achievements
    }

    expose :tutor_recommendation

    expose(:clients) {
      UserTutor.where(tutor: current_user, status: :accepted)
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
          name: current_user.name
        )
      else
        #flash[:error] = I18n.t()
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
        {content_tutor_recommendations: []},
        :tutor_achievement
      )
    end


    def contents_to_recommendation(content_ids)
      content_ids = content_ids.reject(&:blank?)
      if content_ids.any?
        content_ids.each do |id|
          content = Content.find(id)
          content_tutor_recommendation = ContentTutorRecommendation.new(
            tutor_recommendation: tutor_recommendation,
            content: content
          )
          if content_tutor_recommendation.save
            recommendation_to_client(clients, tutor_recommendation, content_ids)
          end
        end
      end
    end

    def recommendation_to_client (clients, recommendation, content_ids)
      clients.find_each do |user_tutor|
        client = user_tutor.user
        TutorService::RecommendationsStatusUpdater.new(
          client,
          recommendation,
          content_ids
        ).perform
      end
    end
  end
end
