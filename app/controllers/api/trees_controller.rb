module Api
  class TreesController < BaseController
    before_action :authenticate_user!

    respond_to :json

    api :GET,
        "/tree",
        "returns tree for current user"
    def show
      respond_with tree, root: :tree
    end

    private

    def tree
      Neuron.where(
        id: TreeService::RootFetcher.root_neuron.id
      )
    end
  end
end
