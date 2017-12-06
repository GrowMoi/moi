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
            "label": "Tests sin errores",
            "description": "",
            "category": "test"
          },
          {
            "id": 2,
            "number": 5,
            "name": "Contenidos aprendidos",
            "label": "Contenidos aprendidos",
            "description": "",
            "category": "content"
          },
          {
            "id": 1,
            "number": 6,
            "name": "Contenidos aprendidos en total",
            "label": "Contenidos aprendidos en total",
            "description": "",
            "category": "content_all"
          }
        ]
      }

      def show
        respond_with(
          user_achievements,
          each_serializer: Api::AdminAchievementSerializer
        )
      end
    end
  end
end
