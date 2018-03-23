module Api
  class TreesController < BaseController
    respond_to :json

    expose(:user) {
      user = User.find_by_username(params[:username])
    }

    expose(:user_tree) {
      if user
        neuronId = params[:neuronId]
        TreeService::UserTreeFetcher.new(user, neuronId)
      end
    }

    expose(:total_approved_contents) {
      Neuron.approved_public_contents.count
    }

    api :GET,
        "/tree",
        "returns tree for current user"
    example %q{
      { "tree": { "root":
          { "id": 1,
            "title": "Neurona 1",
            "state": "florecida",
            "children": [
              { "id": 2,
                "title": "Neurona 2",
                "state": "descubierta",
                "children": [
                  { "id": 3,
                    "title": "Neurona 3",
                    "children": [] }
                ] },
              { "id": 4,
                "title": "Neurona 4",
                "state": "descubierta",
                "children": []}
            ]
          }
        },
        "meta": {
          "depth": 2,
          "depth": 2,
          "current_learnt_contents": 2,
          "total_approved_contents": 20,
          "perform_final_test": false,
          "total_final_test": 0
        }
      }
    }
    param :username, String, required: true
    param :neuronId, Integer

    def show
      user_request = params[:neuronId] ? user_tree : user
      if user_request
        respond_with tree: { root: user_request.root },
                     meta: { depth: user_request.depth,
                            current_learnt_contents: user_request.content_learnings.count,
                            total_approved_contents: total_approved_contents,
                            perform_final_test: user_tree.depth == 9,
                            total_final_test: user_request.learning_final_tests.size
                           }
      else
        render nothing: true,
                status: 404
      end
    end
  end
end
