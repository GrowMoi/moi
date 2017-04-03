module Api
  class UsersController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user)

    api :GET,
        "/users/:id/profile",
        "user's profile"
    param :id, Integer, required: true
    example %q{
      { "age": "23",
        "birthday": "19/23/2000",
        "name": "Jhon Doe"
        "city": "Quito",
        "country": "Ecuador",
        "email": "example@gmail.com",
        "id": "2",
        "last_contents_learnt": [
          "id": "12",
          "media": ["htttp://something.com"]
        ]
      }
    }
    def profile
      respond_with(
        user,
        serializer: Api::UserProfileSerializer
      )
    end

    expose(:search_results) {
      users_results = UserSearch.new(q:params[:query], id:current_user.id).results
      Kaminari.paginate_array(users_results)
        .page(params[:page])
        .per(8)
    }

    api :GET,
        "/users/search",
        "returns search from query"
    param :page, Integer
    param :query, String
    def search
      respond_with(
        search_results,
        meta: {
          total_items: search_results.total_count
        },
        serializer: Api::SearchUsersSerializer
      )
    end
  end
end
