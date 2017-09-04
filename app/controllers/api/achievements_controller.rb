module Api
  class AchievementsController < BaseController

    before_action :authenticate_user!

    PAGE = 1
    PER_PAGE = 5

    expose(:user_achievements) {
      Achievement.all
                .order(created_at: :desc)
                .page(params[:page] || PAGE)
                .per(params[:per_page] || PER_PAGE)
    }

    expose(:achievements_all) {
      result = []
      user_achievements.each do |user_achievement|
        result.push(user_achievement.achievement)
      end
      result
    }

    expose(:user_selected) {
      if params[:user_id]
        selected = User.find(params[:user_id])
      else
        selected = current_user
      end
      selected
    }

    api :GET,
        "/achievements",
        "Get user achievements"
    example %q{
      "achievements": [
        {
          "id": 4,
          "name": "Tiempo aprender contenidos",
          "label": "Tiempo hasta el último contenido aprendido",
          "description": "",
          "category": "time",
          "meta": {
            "exists_contents_learnt": true,
            "time_elapsed": 9409558493
          }
        },
        {
          "id": 3,
          "name": "Tests sin errores",
          "label": "Tests sin errores",
          "description": "",
          "category": "test",
          "meta": {
            "current_tests_ok": 4
          }
        },
        {
          "id": 2,
          "name": "Contenidos aprendidos",
          "label": "Contenidos aprendidos",
          "description": "",
          "category": "content",
          "meta": {
            "learn_all_contents": false,
            "current_contents_learnt": 68,
            "needs_learn": 30
          }
        },
        {
          "id": 1,
          "name": "Contenidos aprendidos en total",
          "label": "Contenidos aprendidos en total",
          "description": "",
          "category": "content_all",
          "meta": {
            "total_contents": 71,
            "learn_all_contents": true,
            "current_contents_learnt": 68
          }
        }
      ],
      "meta": {
        "total_count": 4,
        "total_pages": 1
      }
    }
    param :user_id, Integer

    def index
      if is_client?(user_selected)
        result = serialize_achievements(user_achievements)
        render json: {
          achievements: result,
          meta: {
            total_count: user_achievements.total_count,
            total_pages: user_achievements.total_pages
          }
        }
      else
        render json: {
          achievements: [],
          meta: {}
        }
      end
    end

    private

    def serialize_achievements(achievements_data)
      if params[:user_id]
        user_scope =  User.find(params[:user_id])
      else
        user_scope = current_user
      end

      serialized = ActiveModel::ArraySerializer.new(
        achievements_data,
        each_serializer: Api::AchievementSerializer,
        scope: user_scope
      )
      serialized
    end

    def is_client?(user)
      user.present? && user.cliente?
    end

  end
end
