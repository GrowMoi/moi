module Api
  module Users
    class AdminAchievementsController < BaseController
      before_action :authenticate_user!

      respond_to :json

      expose(:user_achievements) {
        current_user.user_admin_achievements
      }

      api :GET,
          "/users/admin_achievements",
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

      def show
        respond_with(
          user_achievements,
          each_serializer: Api::UserAchievementSerializer
        )
      end
    end
  end
end
