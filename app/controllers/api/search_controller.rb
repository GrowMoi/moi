module Api
  class SearchController < BaseController
    before_action :authenticate_user!
    respond_to :json

    expose(:contents) {
      ContentSearch.new(
        q: params[:query]
      ).results
       .page(params[:page]).per(8)
    }

    api :GET,
        "/search",
        "returns search from query"
    param :page, Integer
    param :query, String
    def index
      respond_with(
        contents,
        meta: {
          total_items: contents.total_count
        },
        each_serializer: Api::ContentSerializer
      )
    end
  end
end
