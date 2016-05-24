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

    def index
      respond_with(neurons, each_serializer: Api::NeuronSerializer)
    end

    api :GET,
        "/search",
        "returns search from query"
    param :page, Integer
    param :query, String
  end
end
