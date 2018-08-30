module Api
  module Users
    class UserImagesController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      api :PUT,
          "/users/user_image",
          "add user image"
      param :image, String

      def update
        if user.update_attribute("image", params[:image])
          response = {
            status: :accepted,
            nothing: true
          }
        else
          response = {
            nothing: true,
            status: :unprocessable_entity
          }
        end
        render json: response,
               status: response[:status]
      end
    end
  end
end
