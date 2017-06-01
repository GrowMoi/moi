module Tutor
  class MoiController < TutorController::Base

    expose(:all_clients) {
      if params[:search]
        UserClientSearch.new(q:params[:search]).results
      else
        User.where(:role => :cliente)
      end
    }

    expose(:my_clients) {
      current_user.tutor_requests_sent.map &:user
    }

    expose(:clients) { all_clients - my_clients }

    def index
    end
  end
end
