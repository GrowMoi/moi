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

      def update
        if user.update(tree_image: params[:image])
          render status: 200, json: {
    				message: "Successfully added user with ID: " + user.id.to_s,
    				tree_image: user.tree_image
    			}
        else
          @errors = current_user.errors
          render  nothing: true,
                  status: unprocessable_entity
        end
      end
    end
  end
end
