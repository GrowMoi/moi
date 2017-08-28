module Api
  class LeaderboardController < BaseController

    before_action :authenticate_user!

    PAGE = 1
    PER_PAGE = 10

    @user_position = 0

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
          total_pages: leaders.total_pages,
          user_position: @user_position
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
          user_content_learnings = ContentLearning.where(user: user).order(created_at: :asc)
          last_content_learnt = user_content_learnings.last
          time_diff = (last_content_learnt.created_at - current_user.created_at).to_i
          data[:time_elapsed] = time_diff
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
      user_times.each.with_index do |user, i|
        position = i + 1
        if user[:id] == current_user.id
          @user_position = position
        end
        user[:time_humanized] = humanize_ms(user[:time_elapsed])
        user[:position] = position
      end
    end

    def paginate_leaders(leaders_data)
      Kaminari.paginate_array(leaders_data)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)
    end

    def humanize_ms(msecs)
      secs = msecs / 1000.0
      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{t('time.units.' + name.to_s)}"
        end
      }.compact.reverse.join(' ')
    end

  end
end
