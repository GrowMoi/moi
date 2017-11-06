module Tutor
  class ClientController < TutorController::Base
    expose(:client_data) {
      User.where(id: params[:id], role: :cliente)
    }

    def show
      @client = client_data.first
      @statistics = @client.generate_statistics(
        [
          "total_neurons_learnt",
          "total_content_readings",
          "total_right_questions"
        ]
      )
    end

    def index
      render
    end

  end
end
