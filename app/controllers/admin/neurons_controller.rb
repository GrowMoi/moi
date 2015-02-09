module Admin
  class NeuronsController < AdminController::Base
    authorize_resource

    expose(:neuron, attributes: :neuron_params)

    private

    def neuron_params

    end
  end
end
