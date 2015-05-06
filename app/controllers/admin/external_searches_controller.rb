module Admin
  class ExternalSearchesController < AdminController::Base
    expose(:search) {
      KnowledgeSearch.new(
        query: params[:q],
        source: params[:provider]
      )
    }

    expose(:results) {
      search.results
    }

    def create
      render json: {
        results: results.map(&:to_hash)
      }
    end
  end
end
