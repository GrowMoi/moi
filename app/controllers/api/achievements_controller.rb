module Api
  class AchievementsController < BaseController

    before_action :authenticate_user!

    api :GET,
        "/achievements",
        "get user achievements"
    example %q{}
    def index
      render json: {
        achievements: [],
        meta: {}
      }
    end

  end
end
