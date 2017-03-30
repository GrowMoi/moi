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

  end
end
