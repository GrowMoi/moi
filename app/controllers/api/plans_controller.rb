module Api
  class PlansController < BaseController

    expose(:plans) {
      Plan.all
    }

    respond_to :json

    api :GET,
        "/plans",
        "returns all plans"
    def index
      respond_with(
        plans,
        each_serializer: Api::PlanSerializer
      )
    end
  end
end
