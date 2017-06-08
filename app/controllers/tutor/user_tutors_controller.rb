module Tutor
  class UserTutorsController < TutorController::Base
    def create
      tutor_request = current_user.tutor_requests_sent.new(
        user_id: params[:user_id]
      )
      if tutor_request.save
        flash[:success] = I18n.t(
          "views.tutor.moi.tutor_request.created",
          name: tutor_request.user.name
        )
      else
        flash[:error] = I18n.t(
          "views.tutor.moi.tutor_request.not_created",
          name: tutor_request.user.name
        )
      end
      redirect_to :back
    end
  end
end
