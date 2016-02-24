module Api
  class BaseController < ::ApplicationController
    module NeuronScope
      extend ActiveSupport::Concern

      included do
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
      end
    end
  end
end