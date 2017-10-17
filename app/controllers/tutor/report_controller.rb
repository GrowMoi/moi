module Tutor
  class ReportController < TutorController::Base

    expose(:user_tutor) {
      UserTutor.where(tutor:current_user, user: params[:user_id], status: :accepted)
                .first
    }

    expose(:users_by_tutor) {
      UserTutor.where(tutor:current_user, status: :accepted).includes(:user)
    }

    expose(:client_data) {
      User.where(id: params[:id], role: :cliente)
    }

    expose(:content_reading_times) {
      client_data.first.content_reading_times
    }

    expose(:reading_time_content_ids) {
      content_reading_times.select(:content_id)
                           .group(:content_id)
                           .pluck(:content_id)
    }

    def index
      if user_tutor.present?
        @client = user_tutor.user
        @statistics = @client.generate_statistics
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

    def analytics_details
      data = {}
      if user_tutor.present?
        client = user_tutor.user
        data = generate_analytics_details(client, users_by_tutor, params[:fields])
      end
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

    def map_users_by_params(client, users, param)
      result = nil

      if !param.empty?
        max_value = get_max_value(users, param)
        value = client.generate_statistics([param])
        result = {
          max_value: max_value,
          value: value[param],
          user_id: client.id
        }
      end
      result
    end

    def generate_analytics_details(client, users, params_data = [])
      analytics = {}
      params_data.each do |param|
        result = map_users_by_params(client, users, param)
        if result.present?
          analytics[param] = result
        end
      end
      analytics
    end

    def get_max_value(users, param)
      result = users.map do |d|
        statistic = d.user.generate_statistics([param])
        statistic[param]
      end
      result.max
    end
  end
end
