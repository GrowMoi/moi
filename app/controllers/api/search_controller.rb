module Api
  class SearchController < BaseController
    before_action :authenticate_user!
    respond_to :json

    expose(:neurons) {
      NeuronSearch.new(
        q: params[:query]
      ).results
       .send('active')
       .page(params[:page]).per(8)
    }

    api :GET,
        "/search",
        "returns search from query"
    param :page, Integer
    param :query, String
    def index
      respond_with(
        neurons,
        meta: {
          total_items: neurons.total_count
        },
        each_serializer: Api::NeuronSerializer
      )
    end
  end
end
