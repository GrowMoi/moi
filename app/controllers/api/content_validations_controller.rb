module Api
  class ContentValidationsController < BaseController
    before_action :authenticate_user!
    respond_to :json

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
    param :text, String

    def send_request
      new_request_content = RequestContentValidation.new(
        user: current_user,
        content: content,
        media: params[:media],
        text: params[:text]
      )
      if new_request_content.save
        # TODO: Notify Tutor a new request
        render nothing: true,
               status: :accepted
      else
        render text: new_request_content.errors.full_messages,
              status: :unprocessable_entity,
              errors: new_request_content.errors.full_messages
      end
    end

    api :POST,
        "/content_validations/start_validation",
        "Take a request to start to validate"
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
        render text: check_content.errors.full_messages,
              status: :unprocessable_entity,
              errors: check_content.errors.full_messages
      end
    end

    api :PUT,
        "/content_validations/checked",
        "Send a notification with an answer about request"
    param :check_request_id, String
    param :message, String
    # param :approved, Boolean

    def checked
      check_request_content.message = params[:message]
      check_request_content.approved = params[:approved]
      if check_request_content.save
        request_content.approved = check_request_content.approved
        request_content.save
        create_notification(check_request_content)
        render nothing: true,
               status: :accepted
      else
        render text: check_content.errors.full_messages,
              status: :unprocessable_entity,
              errors: check_content.errors.full_messages
      end
    end

    private

    def create_notification(check_request_content)
      notification = ClientNotification.new(
        client_id: request_content.user_id,
        data_type: "client_got_validation_content",
        data: {
          approved: check_request_content.approved,
          message: check_request_content.message,
          content_title: request_content.content.title,
          content_id: request_content.content.id,
          neuron_id: request_content.content.neuron.id,
        }
      )
      if notification.save
        channel = "tutornotifications.#{check_request_content.reviewer.id}"
        notification.send_pusher_notification(channel, "client_got_validation_content")
      end
    end
  end
end
