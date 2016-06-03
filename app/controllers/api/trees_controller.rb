module Api
  class TreesController < BaseController
    before_action :authenticate_user!

    respond_to :json

    api :GET,
        "/tree",
        "returns tree for current user"
    example %q{
{ "tree":
  { "root":
    { "id": 1,
      "title": "Neurona 1",
      "children": [
        { "id": 2,
          "title": "Neurona 2",
          "children": [
            { "id": 3,
              "title": "Neurona 3",
              "children": [] }
          ] },
        { "id": 4,
          "title": "Neurona 4",
          "children": []}
      ]
    }
  }
}
    }

    def show
      respond_with tree: { root: root }
    end

    private

    def root
      TreeService::UserTreeFetcher.new(
        current_user
      ).root
    end
  end
end
