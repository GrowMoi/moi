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

        begin
          user.save
          response = {
            status: :accepted,
            user: user
          }
          render json: response, status: :accepted
        rescue Exception => e
          render json: {
            status: :accepted,
            success: false,
            message: "Failed to upload image. Please try after some time.",
            user: user
          }
        end
      end
    end
  end
end
