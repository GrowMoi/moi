module Admin
  class DashboardController < AdminController::Base
    expose(:neurons) {
      NeuronSearch.custom_search(
        scope: neuron_scope,
        q: params[:q]
      ).results
    }
    expose(:neuron_scope) {
      Neuron.where(state: state)
    }
    expose(:neurons_state) {
      state = params[:state]
      if Neuron.states.has_key?(state)
        state
      else
        default_state
      end
    }

    private

    def state
      Neuron.states.fetch(params[:state]) {
        Neuron.states.fetch(default_state)
      }
    end

    def default_state
      "approved"
    end
  end
end
