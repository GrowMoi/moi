module Api
  class RecommendedContentsController < BaseController

    respond_to :json

    api :GET,
        "/neurons/:neuron_id/recommended_contents/:kind",
        "recommended contents of a given kind for a neuron"
    param :neuron_id, Integer, required: true
    param :kind, String, required: true
    def show
     respond_with(
      ActiveModel::ArraySerializer.new(
        recommended_contents,
        root: :contents,
        each_serializer: current_user ? Api::ContentSerializer : Api::ContentPublicSerializer,
        scope: current_user
      )
    )
    end

    private

    def recommended_contents
      TreeService::RecommendedContentsFetcher.new(
        kind: params[:id],
        user: current_user,
        neuron: neuron
      ).contents
    end
  end
end
