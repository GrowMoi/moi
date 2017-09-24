module Tutor
  class ReportController < TutorController::Base

    expose(:user_tutor) {
      UserTutor.where(tutor:current_user, user: params[:user_id], status: :accepted)
                .first
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

  end
end
