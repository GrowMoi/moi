module Admin
  class DashboardController < AdminController::Base
    expose(:neurons) {
      NeuronSearch.new(
        q: params[:q]
      ).results
        .send(neuron_scope)
        .accessible_by(current_ability, :index)
        .page(params[:page]).per(18)
    }
    expose(:decorated_neurons) {
      decorate neurons
    }

    expose(:neuron_scope) {
      fail ActiveRecord::RecordNotFound unless states.include?(state)
      state.to_sym
    }

    private

    def state
      params[:state].present? ? params[:state] : "active"
    end

    def states
      Neuron::STATES
    end
  end
end
