module Api
  class ContentValidationsController < BaseController
    before_action :authenticate_user!

    expose(:content) {
      Content.find(params[:content_id])
    }

    expose(:request_content) {
      RequestContentValidation.find(params[:request_id])
    }

    expose(:check_request_content) {
      CheckContentValidation.find(params[:check_request_id])
    }

    api :POST,
        "/content_validations/send",
        "Send a request to validate img/video upload an specific neuron"
    param :content_id, String
    param :media, String

    def send_request
      new_request_content = RequestContentValidation.new(
        user: current_user,
        content: content,
        media: params[:media]
      )
      if new_request_content.save
        # TODO: Notify Tutor a new request
        render nothing: true,
               status: :accepted
      else
        render status: :unprocessable_entity,
               errors: new_request_content.errors
      end
    end

    api :POST,
        "/content_validations/start_validation",
        "Send a request to validate img/video upload an specific neuron"
    param :request_id, String

    def start_validation
      check_content = CheckContentValidation.new(
        reviewer: current_user,
        request_content_validation: request_content,
      )
      if check_content.save
        request_content.in_review = true;
        request_content.save;
        # TODO: Notify User
        render nothing: true,
               status: :accepted
      else
        render status: :unprocessable_entity,
               errors: check_content.errors
      end
    end

    api :POST,
        "/content_validations/start_validation",
        "Send a request to validate img/video upload an specific neuron"
    param :check_request_id, String
    param :message, String
    # param :approved, Boolean

    def checked
      check_request_content.message = params[:message]
      check_request_content.approved = params[:approved]

      if check_request_content.save
        # TODO: Notify User
        render nothing: true,
               status: :accepted
      else
        render status: :unprocessable_entity,
               errors: check_request_content.errors
      end
    end
  end
end
