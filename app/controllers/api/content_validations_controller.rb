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
        "/content_validations/send_request",
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
        create_notifications_for_tutor(new_request_content)
        render nothing: true,
               status: :accepted
      else
        render text: new_request_content.errors.full_messages,
              status: :unprocessable_entity,
              errors: new_request_content.errors.full_messages
      end
    end

    api :POST,
        "/content_validations/checked",
        "Send a notification with an answer about request"
    param :check_request_id, String
    param :message, String
    # param :approved, Boolean

    def checked
      check_request_content = CheckContentValidation.new(
        reviewer: current_user,
        request_content_validation: request_content,
        message: params[:message],
        approved: params[:approved]
      )
      if check_request_content.save
        request_content.approved = check_request_content.approved
        request_content.save
        create_notification(check_request_content)
        render nothing: true,
               status: :accepted
      else
        render text: check_request_content.errors.full_messages,
              status: :unprocessable_entity,
              errors: check_request_content.errors.full_messages
      end
    end

    private

    def create_notifications_for_tutor(new_request_content)
      tutors = UserTutor.where(user: current_user)
      tutors.map do |tutor|
        notification = ClientNotification.new(
          client_id: current_user.id,
          data_type: "client_need_validation_content",
          data: {
            new_request_content_id: new_request_content.id,
            tutor_id: tutor.tutor_id,
            data_type: "client_need_validation_content"
          }
        )
        if notification.save
          channel = "tutornotifications.#{tutor.tutor_id}"
          notification.send_pusher_notification(channel, "client_need_validation_content")
        end
      end
    end


    def create_notification(check_request_content)
      notification = Notification.new(
        client_id: request_content.user_id,
        data_type: "tutor_validated_content",
        user_id: current_user.id,
        data: {
          approved: check_request_content.approved,
          message: check_request_content.message,
          content_title: request_content.content.title,
          content_id: request_content.content.id,
          neuron_id: request_content.content.neuron.id,
        }
      )
      notification.save
    end
  end
end
