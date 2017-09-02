module Api
  class LeaderboardController < BaseController

    before_action :authenticate_user!

    PAGE = 1
    PER_PAGE = 10

    @user_data = {}

    expose(:all_clents) {
      User.where(role: :cliente)
    }

    expose(:total_content_available) {
      Content.joins(:neuron)
            .where(approved: :true, neurons: {is_public: true})
            .size
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
          "current_contents_learnt": 68,
          "total_contents": 71,
          "time_elapsed": 9409558493,
          "position": 1
        },
        {
          "id": 3,
          "email": "usuario3@test.com",
          "name": "usuario3",
          "current_contents_learnt": 14,
          "total_contents": 71,
          "time_elapsed": 3067483,
          "position": 2
        },
        {
          "id": 2,
          "email": "usuario2@test.com",
          "name": "usuario2",
          "current_contents_learnt": 9,
          "total_contents": 71,
          "time_elapsed": 3992873,
          "position": 3
        }
      ],
      "meta": {
        "total_count": 3,
        "total_pages": 1,
        "user_data": {
          "id": 1,
          "email": "usuario1@test.com",
          "name": "usuario1",
          "current_contents_learnt": 68,
          "total_contents": 71,
          "time_elapsed": 9409558493,
          "position": 1
        }
      }
    }
    param :user_id, Integer

    def index
      leaders = paginate_leaders(generate_leaders)
      render json: {
        leaders: leaders,
        meta: {
          total_count: leaders.total_count,
          total_pages: leaders.total_pages,
          user_data: @user_data
        }
      }
    end

    private

    def generate_leaders
      user_times = []
      users = all_clents
      users.find_each do |user|
        data = {
          id: user.id,
          email: user.email,
          name: user.name,
          current_contents_learnt: user.learned_contents.size,
          total_contents: total_content_available
        }

        if user.learned_contents.empty?
          data[:time_elapsed] = 0
        else
          user_content_learnings = ContentLearning.where(user: user).order(created_at: :asc)
          last_content_learnt = user_content_learnings.last
          time_diff = last_content_learnt.created_at - user.created_at
          milliseconds = (time_diff.to_f.round(3)*1000).to_i
          data[:time_elapsed] = milliseconds
        end
        user_times.push(data)
      end
      user_times = sort_times(user_times)
      user_times = add_times_index(user_times)
      user_times
    end

    def sort_times(user_times)
      user_times.sort_by {|d| [d[:current_contents_learnt], -d[:time_elapsed]]}.reverse
    end

    def add_times_index(user_times)
      user_id = params[:user_id] || current_user.id
      user_times.each.with_index do |user, i|
        position = i + 1
        if user[:id] == user_id.to_i
          @user_data = user
        end
        user[:position] = position
      end
      user_times
    end

    def paginate_leaders(leaders_data)
      Kaminari.paginate_array(leaders_data)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)
    end

  end
end
