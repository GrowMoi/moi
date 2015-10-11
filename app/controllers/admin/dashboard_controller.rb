module Admin
  class DashboardController < AdminController::Base
    expose(:neurons) do
      NeuronSearch.new(
        q: params[:q]
      ).results
        .send(neuron_scope)
        .accessible_by(current_ability, :index)
        .page(params[:page]).per(18)
    end
    expose(:decorated_neurons) do
      decorate neurons
    end

    expose(:neuron_scope) do
      fail ActiveRecord::RecordNotFound unless Neuron::STATES.include?(state)
      state.to_sym
    end

    private

    def state
      params[:state].present? ? params[:state] : "active"
    end
  end
end
