module Tutor
  class RecommendationsController < TutorController::Base

    expose(:content_search) {
      query = params[:query] || ""
      ContentSearch.new(q: query)
    }

    expose(:contents) {
      Content.where(approved: true)
    }

    expose(:tutor_achievements) {
      current_user.tutor_achievements
    }

    expose(:tutor_recommendation) {
      TutorRecommendation.new
    }

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

  end
end
