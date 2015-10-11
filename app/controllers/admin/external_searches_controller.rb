module Admin
  class ExternalSearchesController < AdminController::Base
    expose(:search) do
      KnowledgeSearch.new(
        query: params[:q],
        source: params[:provider]
      )
    end

    expose(:results) do
      search.results
    end

    def create
      authorize! :search, Content
      render json: {
        results: formatted_results
      }
    end

    private

    def formatted_results
      results.map do |result|
        hash = result.to_hash
        if result.pagemap && result.pagemap.to_hash.key?("cse_thumbnail")
          hash.merge!(
            thumbnail: result.pagemap.cse_thumbnail.first.to_hash
          )
        end
        hash
      end
    end
  end
end
