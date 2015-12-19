module Api
  class NeuronsController < BaseController
    expose(:neurons) {
      # TODO: revise scope
      Neuron.published # .accessible_by(current_ability) -> shouldn't be quering only public ?
            .includes(:contents)
            .page(params[:page])
    }
    expose(:neuron)

    respond_to :json

    def index
      respond_with neurons, each_serializer: neuron_serializer
    end

    def show
      respond_with neuron, serializer: neuron_serializer
    end

    private

    def neuron_serializer
      Api::NeuronSerializer
    end

  end

end
