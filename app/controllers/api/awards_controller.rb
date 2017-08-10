module Api
  class AwardsController < BaseController

    before_action :authenticate_user!

    api :GET,
        "/awards",
        "get user awards"
    example %q{}
    def index
      render json: {
        awards: [],
        meta: {}
      }
    end

  end
end
