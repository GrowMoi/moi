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
      Neuron.approved_public_contents.count
    }

    expose(:all_leaders) {
      Leaderboard.includes(:user)
                # .where('users.age' => 10)
                .order(contents_learnt: :desc, time_elapsed: :asc)
    }

    expose(:all_schools) {
      User.all.map(&:school).uniq.compact
    }

    expose(:all_ages) {
      User.all.map(&:age).uniq.compact
    }

    expose(:all_cities) {
      User.all.map(&:city).uniq.compact
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
          "achievements": 7,
          "time_elapsed": 9409558493,
          "user_id": 10
        },
        {
          "id": 3,
          "email": "usuario3@test.com",
          "name": "usuario3",
          "contents_learnt": 14,
          "achievements": 5,
          "time_elapsed": 3067483,
          "user_id": 12
        },
        {
          "id": 2,
          "email": "usuario2@test.com",
          "name": "usuario2",
          "contents_learnt": 9,
          "achievements": 4,
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
          "achievements": 7,
          "time_elapsed": 9409558493,
          "user_id": 10,
          "position": 1
        }
      }
    }
    param :user_id, Integer
    param :event_id, Integer

    def index
      user_selected = get_user_selected
      leaderboard = {}
      if is_client?(user_selected)
        current_leader_item = Leaderboard.includes(:user).find_by_user_id(user_selected.id)
        unless current_leader_item
          current_leader_item = create_leader_item(user_selected)
        end

        last_super_event = user_selected.my_super_events.last
        user_achievement_ids = last_super_event ? last_super_event.user_achievement_ids : []
        total_super_event_achievements = user_achievement_ids.count

        if from_event?
          leaderboard = get_event_leaders(user_selected, current_leader_item, user_achievement_ids)
        else
          leaderboard = get_all_leaders(user_selected)
        end

        user_data = leaderboard[:user_data]
        leaders = leaderboard[:leaders]
        serialized_leaders = leaderboard[:serialized_leaders]

        render json: {
          leaders: serialized_leaders,
          meta: {
            total_count: leaders.total_count,
            total_pages: leaders.total_pages,
            user_data: user_data,
            total_contents: total_content_available,
            total_super_event_achievements: total_super_event_achievements
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

    def serialize_leaders(leaders, serializer, user_achievement_ids=[])
      serialized = ActiveModel::ArraySerializer.new(
        leaders,
        each_serializer: serializer,
        scope: user_achievement_ids
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

    def from_event?
      params[:event_id].present?
    end

    def get_event_leaders(user_selected, current_leader_item, user_achievement_ids)
      event_id = params[:event_id]
      sorted_leaders = []
      user_data = {}
      user_event_achievement = UserEventAchievement.where(event_achievement_id: event_id, user_id: user_selected.id).last

      if user_event_achievement
        user_ids_by_event = UserEventAchievement.includes(:user)
          .where(event_achievement_id: event_id)
          .pluck(:user_id)

        achievement_leaders = all_leaders.where(user_id: user_ids_by_event)

        event_achievement_ids = user_event_achievement.event_achievement.user_achievement_ids
        sorted_leaders =  sort_leaders(achievement_leaders, event_achievement_ids)
        user_index = sorted_leaders.index(current_leader_item)
        serialized_data = Api::LeaderboardSerializer.new(current_leader_item).as_json
        user_data = serialized_data["leaderboard"]
        user_data[:position] = user_index + 1
      end

      leaders = Kaminari.paginate_array(sorted_leaders)
                        .page(params[:page] || PAGE)
                        .per(params[:per_page] || PER_PAGE)

      return {
        leaders: leaders,
        serialized_leaders: serialize_leaders(leaders, Api::LeaderboardSerializer, user_achievement_ids),
        user_data: user_data
      }
    end

    def get_all_leaders(user_selected)
      leaders =  all_leaders.page(params[:page] || PAGE).per(params[:per_page] || PER_PAGE)
      user_data = {}
      if exists_relation(user_selected)
        user_index = all_leaders.pluck(:user_id).index(user_selected.id)
        user_info = all_leaders.find_by_user_id(user_selected.id)
        serialized_data = Api::LeaderboardSerializer.new(user_info).as_json
        user_data = serialized_data["leaderboard"]
        if user_index
          user_data[:position] = user_index + 1
        end
      else
        achievement_leaders = all_leaders.where(user_id: user_ids_by_event)
        serialized_data = Api::LeaderboardSerializer.new(Leaderboard.new(
          user_id: user_selected.id,
          contents_learnt: 0,
          time_elapsed: 0
        )).as_json
        user_data = serialized_data["leaderboard"]
        user_data[:position] = achievement_leaders.count + 1
      end

      return {
        leaders: leaders,
        serialized_leaders: serialize_leaders(leaders, Api::LeaderboardSerializer),
        user_data: user_data
      }
    end

    def sort_leaders(achievement_leaders, event_achievement_ids)
      sorted_leaders = achievement_leaders.sort do |achievement_leader1, achievement_leader2|
        user_achievement_ids1 = achievement_leader1.user.my_achievements.pluck(:id)
        intersection1 = user_achievement_ids1 & event_achievement_ids
        achieved_achievements_count1 = intersection1.count

        user_achievement_ids2 = achievement_leader2.user.my_achievements.pluck(:id)
        intersection2 = user_achievement_ids2 & event_achievement_ids
        achieved_achievements_count2 = intersection2.count

        (achieved_achievements_count1 <=> achieved_achievements_count2) == 0 ?
        (achievement_leader1.contents_learnt <=> achievement_leader2.contents_learnt) :
        (achieved_achievements_count1 <=> achieved_achievements_count2)
      end
      sorted_leaders.reverse
    end

    def create_leader_item(user_selected)
      time_elapsed = UtilService.new(user_selected).generate_elapsed_time()
      Leaderboard.create!(
        user_id: user_selected.id,
        contents_learnt: user_selected.content_learnings.count,
        time_elapsed: time_elapsed
      )
    end

  end
end
