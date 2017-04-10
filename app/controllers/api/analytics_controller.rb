module Api
  class AnalyticsController < BaseController
    before_action :authenticate_user!

    expose(:statistics_data) {
      current_user.generate_statistics()
    }

    respond_to :json

    api :GET,
        "/analytics/statistics"

    def statistics
      respond_with(
        statistics_data,
        serializer: Api::StatisticsSerializer
      )
    end

  end
end
