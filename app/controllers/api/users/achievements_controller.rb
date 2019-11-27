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
          "Just active or disable an achievement"

      param :id, Integer, required: true

      def active
        achievements = UserAdminAchievement.where(user_id: current_user.id)
        achievements.each do |achievement|
          if achievement.id == params[:id].to_i
            achievement.active = !achievement.active
            avatar = achievement.admin_achievement.settings['avatar']
            unless avatar.nil? 
              current_user.avatar = achievement.active ? avatar : nil
              current_user.save
            end
          else
            achievement.active = false
          end
          achievement.save
        end
        render json: {
          avatar: get_avatar,
          status: :ok
        }
      end

      private

      def get_avatar
        if current_user.avatar && current_user.gender
          folder = current_user.gender === "M" ? "mens" : "women"
          path = "#{Rails.application.secrets.url}/avatars/#{folder}#{UserAvatars.avatars[:"#{current_user.avatar}"]}"
        end
      end
    end
  end
end
