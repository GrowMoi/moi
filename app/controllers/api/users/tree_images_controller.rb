module Api
  module Users
    class TreeImagesController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      api :PUT,
          "/users/tree_image",
          "create user tree"
      param :image, String
      param :image_app, String

      def update
        if(params[:image_app])
          user.tree_image_app = params[:image_app]
        else
          user.tree_image = params[:image]
        end

        if user.save
          response = {
            status: :accepted,
            user: user
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
