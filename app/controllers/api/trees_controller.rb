module Api
  class TreesController < BaseController
    before_action :authenticate_user!

    respond_to :json

    api :GET,
        "/tree",
        "returns tree for current user"
    def show
      respond_with tree: tree
    end

    private

    def tree
      TreeService::UserTreeFetcher.new(
        current_user
      ).root
    end
  end
end
