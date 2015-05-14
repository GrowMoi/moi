module Admin
  class DashboardController < AdminController::Base
    expose(:neurons) {
      Neuron.try(neurons_state.to_sym)
    }
    expose(:neurons_state) {
      params[:state] ||= "approved"
    }
  end
end
