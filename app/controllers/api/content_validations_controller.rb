module Api
  class ContentValidationsController < BaseController
    before_action :authenticate_user!

    expose(:content) {
      Content.find(params[:id])
    }

    api :POST,
        "/content_validations/:id/send(",
        "Send a request to validate img/video upload an specific neuron"
    param :media, String

    def send
      request_content = RequestContentValidation.new
      request_content.user = current_user
      request_content.content = content
      request_content.media = params[:media]
      if request_content.save
        render nothing: true,
               status: :accepted
      else
        render status: :unprocessable_entity,
               errors: request_content.errors
      end
    end
  end
end
