module Tutor
  class ReportController < TutorController::Base

    expose(:user_tutor) {
      UserTutor.where(tutor:current_user, user: params[:user_id], status: :accepted)
                .first
    }

    expose(:users_by_tutor) {
      UserTutor.where(tutor:current_user).includes(:user)
    }

    def index
      if user_tutor.present?
        @client = user_tutor.user
        @statistics = @client.generate_statistics
        @statistics["total_right_questions"] = AnalyticService::UtilsStatistic.new(@client, @statistics).total_right_questions
      end
      render layout: "tutor_report"
    end

    def root_contents_learnt
      data = []
      if user_tutor.present?
        user = user_tutor.user
        data = AnalyticService::UtilsStatistic.new(user, nil).format_donut_chart_data
      end
      render json: {
        data: data
      }
    end

    def tutor_users_contents_learnt
      data = map_users_by_tutor(users_by_tutor)
      render json: {
        data: data
      }
    end

    def map_users_by_tutor(array_data)
      array_data.map do |data|
        user = data.user
        {
          user_id: user.id,
          name: user.name,
          contents_learnt: user.content_learnings.size
        }
      end
    end
  end
end
