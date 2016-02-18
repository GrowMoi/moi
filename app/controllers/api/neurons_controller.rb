module Api
  class NeuronsController < BaseController
    # TODO:
    # require authentication in these endpoints

    expose(:neurons) {
      # TODO: revise scope (see #neurons_to_learn)
      Neuron.published # .accessible_by(current_ability) -> shouldn't be quering only public ?
            .includes(:contents)
            .page(params[:page])
    }
    expose(:neurons_to_learn) {
      # TODO: this should be `neurons` scope
      # scope should be the neurons the user
      # has learnt + the neurons he's yet to
      # learn
      # ATM only root is sent to the user,
      # until we figure out how to learn, etc
      [ root_neuron ]
    }
    expose(:neuron)
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
        each_serializer: neuron_serializer
      )
    end

    api :GET,
        "/neurons/:id",
        "shows neuron"
    param :id, Integer, required: true
    def show
      respond_with neuron, serializer: neuron_serializer
    end

    private

    def neuron_serializer
      Api::NeuronSerializer
    end

  end

end
