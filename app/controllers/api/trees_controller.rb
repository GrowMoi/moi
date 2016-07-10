module Api
  class TreesController < BaseController
    before_action :authenticate_user!

    respond_to :json

    api :GET,
        "/tree",
        "returns tree for current user"
    example %q{
      { "tree": { "root":
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
        },
        "meta": { "depth": 2 }
      }
    }
    def show
      respond_with tree: { root: user_tree.root },
                   meta: { depth: user_tree.depth }
    end

    expose(:user_tree) {
      TreeService::UserTreeFetcher.new current_user
    }
  end
end
