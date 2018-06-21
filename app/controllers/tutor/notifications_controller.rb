module Tutor
  class NotificationsController < TutorController::Base

    expose(:tutor_students) {
      current_user.tutor_requests_sent.accepted.map(&:user)
    }

    expose(:student_ids) {
      tutor_students.map(&:id)
    }

    expose(:client_notifications) {
      ClientNotification.where(client: student_ids)
    }

    def index
      render
    end

    def info
      render json: client_notifications,
      each_serializer: Api::ClientNotificationSerializer,
      root: "data"
    end

  end
end
