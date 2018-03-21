module Api
  module Users
    class SharedContentsController < BaseController
      before_action :authenticate_user!

      api :POST,
      "/api/users/shared_contents/send",
      "Send a email with an screenshot(Shared content)"
      param :email, String
      param :public_url, String
      param :image_url, String

      def send
        binding.pry
        areValidParams = !params[:email].blank? && !params[:public_url].blank? && !params[:image_url].blank?
        if (areValidParams)
          binding.pry
          UserMailer.shared_content(
            current_user.username,
            params[:email],
            params[:image_url],
            params[:public_url]).deliver_now
        else
          render text: "invalid params",
                status: :unprocessable_entity
        end
      end
    end
  end
end