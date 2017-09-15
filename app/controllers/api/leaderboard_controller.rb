module Api
  class LeaderboardController < BaseController

    before_action :authenticate_user!

    PAGE = 1
    PER_PAGE = 10

    @user_data = nil

    expose(:all_clents) {
      User.where(role: :cliente)
    }

    expose(:total_content_available) {
      Content.joins(:neuron)
            .where(approved: :true, neurons: {is_public: true})
            .size
    }

    expose(:all_leaders) {
      Leaderboard.includes(:user)
                .order(contents_learnt: :desc, time_elapsed: :asc)
    }

    api :GET,
        "/leaderboard",
        "Get leaderboard"
    example %q{
      "leaders": [
        {
          "id": 1,
          "email": "usuario1@test.com",
          "name": "usuario1",
          "contents_learnt": 68,
          "time_elapsed": 9409558493,
          "user_id": 10
        },
        {
          "id": 3,
          "email": "usuario3@test.com",
          "name": "usuario3",
          "contents_learnt": 14,
          "time_elapsed": 3067483,
          "user_id": 12
        },
        {
          "id": 2,
          "email": "usuario2@test.com",
          "name": "usuario2",
          "contents_learnt": 9,
          "time_elapsed": 3992873,
          "user_id": 22
        }
      ],
      "meta": {
        "total_count": 3,
        "total_pages": 1,
        "total_contents": 71,
        "user_data": {
          "id": 1,
          "email": "usuario1@test.com",
          "name": "usuario1",
          "contents_learnt": 68,
          "time_elapsed": 9409558493,
          "user_id": 10,
          "position": 1
        }
      }
    }
    param :user_id, Integer

    def index
      user_selected = get_user_selected
      if is_client?(user_selected)
        leaders =  all_leaders.page(params[:page] || PAGE).per(params[:per_page] || PER_PAGE)
        if exists_relation(user_selected)
          user_index = all_leaders.pluck(:user_id).index(user_selected.id)
          user_info = all_leaders.find_by_user_id(user_selected.id)
          serialized_data = Api::LeaderboardSerializer.new(user_info).as_json
          user_data = serialized_data["leaderboard"]
          user_data[:position] = user_index + 1
        end
        leaderboard = serialize_leaderboard(leaders)
        render json: {
          leaders: leaderboard,
          meta: {
            total_count: leaders.total_count,
            total_pages: leaders.total_pages,
            user_data: user_data,
            total_contents: total_content_available
          }
        }
      else
        render json: {
          leaders: [],
          meta: {}
        }
      end

    end

    private

    def serialize_leaderboard(leaders)
      serialized = ActiveModel::ArraySerializer.new(
        leaders,
        each_serializer: Api::LeaderboardSerializer
      )
      serialized
    end

    def exists_relation(user_selected)
      relation = Leaderboard.where(user_id: user_selected.id)
      relation.present?
    end

    def get_user_selected
      if params[:user_id]
        selected = User.find(params[:user_id])
      else
        selected = current_user
      end
      selected
    end

    def is_client?(user)
      user.present? && user.cliente?
    end

  end
end
