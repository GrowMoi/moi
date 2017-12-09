module Api
  module Users
    class AchievementsController < BaseController
      before_action :authenticate_user!

      respond_to :json

      expose(:user_achievements) {
        current_user.user_admin_achievements
      }

      api :GET,
          "/users/achievements",
          "Get user achievements"
      example %q{
        "achievements": [
          {
            "id": 3,
            "number": 4,
            "name": "Tests sin errores",
            "active": "false"
          },
          {
            "id": 2,
            "number": 5,
            "name": "Contenidos aprendidos",
            "active": "true"
          },
          {
            "id": 1,
            "number": 6,
            "name": "Contenidos aprendidos en total",
            "active": "false"
          }
        ]
      }

      def index
        respond_with(
          user_achievements,
          each_serializer: Api::UserAchievementSerializer
        )
      end

      api :PUT,
          "/users/achievements/:id/active",
          "Active or disable an achievements"

      param :id, Integer, required: true

      def active
        achievement = UserAdminAchievement.find(params[:id])
        achievement.active = !achievement.active
        achievement.save
        render nothing: true,
               status: :ok
      end
    end
  end
end
