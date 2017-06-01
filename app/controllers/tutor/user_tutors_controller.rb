module Tutor
  class UserTutorsController < TutorController::Base
    def create
      tutor_request = current_user.tutor_requests_sent.new(
        user_id: params[:user_id]
      )
      tutor_request.save
      redirect_to :back
    end
  end
end
