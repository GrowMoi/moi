module Api
  class LeaderboardController < BaseController

    before_action :authenticate_user!

    PAGE = 1
    PER_PAGE = 10

    expose(:all_clents) {
      User.where(role: :cliente)
    }

    api :GET,
        "/leaderboard",
        ""
    example %q{}
    def index
      leaders = paginate_leaders(generate_leaders)
      render json: {
        leaders: leaders,
        meta: {
          total_count: leaders.total_count,
          total_pages: leaders.total_pages
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
          total_contents: Content.where(approved: :true).size
        }

        if user.learned_contents.empty?
          data[:time_elapsed] = 0
        else
          user_content_learnings = ContentLearning.where(user: user)
                                                .order(created_at: :asc)
          last_content_learnt = user_content_learnings.last
          first_content_learnt = user_content_learnings.first

          data[:time_elapsed] = (last_content_learnt.created_at - first_content_learnt.created_at).to_i
        end

        user_times.push(data)
      end

      user_times.sort_by {|d| [d[:current_contents_learnt], -d[:time_elapsed]]}.reverse
    end

    def paginate_leaders(leaders_data)
      Kaminari.paginate_array(leaders_data)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)
    end

  end
end
