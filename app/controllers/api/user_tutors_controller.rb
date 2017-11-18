module Api
  class UserTutorsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user_tutor) {
      scope = current_user.tutor_requests_received.pending
      scope.find params[:id]
    }

    api :POST,
        "/user_tutors/:id/respond",
        "respond (accept or reject) a **pending** tutor request"
    param :response, UserTutor::STATUSES, required: true
    def respond
      user_tutor.update_attributes(status: params[:response])
      if user_tutor.status == "accepted"
        client = user_tutor.user
        tutor = user_tutor.tutor
        TutorService::RecommendationsUpdater.new(client, tutor).update
      end
      user_tutor.destroy if user_tutor.status == "rejected"
      render json: UserTutorSerializer.new(user_tutor),
             status: :accepted
    end
  end
end
