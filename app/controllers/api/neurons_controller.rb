module Api
  class NeuronsController < BaseController
    # TODO:
    # require authentication in these endpoints

    expose(:root_neuron) {
      TreeService::RootFetcher.root_neuron
    }

    respond_to :json

    api :GET,
        "/neurons",
        "returns paged neurons"
    param :page, String
    def index
      respond_with(
        neurons_to_learn,
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
      respond_with(
        neuron,
        serializer: Api::NeuronSerializer
      )
    end
  end
end
