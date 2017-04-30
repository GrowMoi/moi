module Tutor
  class MoiController < TutorController::Base
    expose(:clients) {
      User.where(:role => :cliente)
    }
    def index
    end
  end
end
