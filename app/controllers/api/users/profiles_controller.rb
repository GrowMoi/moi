module Api
  module Users
    class ProfilesController < BaseController
      respond_to :json

      expose(:user) {
        user = User.find_by_username(params[:username])
      }

      api :GET,
          "/users/profile",
          "Get basic information user"

      def show
        respond_with(
          user,
          serializer: Api::UserProfileSerializer
        )
      end
    end
  end
end
