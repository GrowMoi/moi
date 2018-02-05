module Api
  class NeuronsController < BaseController

    expose(:root_neuron) {
      TreeService::RootFetcher.root_neuron
    }

    respond_to :json

    api :GET,
        "/neurons",
        "returns tree neurons. Deprecated in favour of /api/tree",
        deprecated: true
    param :page, String
    def index
      respond_with(
        neurons,
        meta: {
          root_id: root_neuron.id
        },
        each_serializer: Api::NeuronSerializer
      )
    end

    api :GET,
        "/neurons/:id",
        "shows neuron"
    param :id, Integer, required: true
    def show
      serializer = current_user ? Api::NeuronSerializer : Api::NeuronPublicSerializer
      respond_with(
        neuron,
        serializer: serializer
      )
    end
  end
end
