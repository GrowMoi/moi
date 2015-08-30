module Admin
  class DashboardController < AdminController::Base
    expose(:neurons) {
      Neuron.send(neuron_scope)
    }

    expose(:neuron_scope) {
      raise ActiveRecord::RecordNotFound unless Neuron::STATES.include?(state)
      state.to_sym
    }

    private

    def state
      params[:state].present? ? params[:state] : "active"
    end
  end
end
