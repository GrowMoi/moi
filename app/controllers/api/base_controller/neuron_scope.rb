module Api
  class BaseController < ::ApplicationController
    module NeuronScope
      extend ActiveSupport::Concern

      included do
        expose(:neuron_scope) {
          TreeService::PublicScopeFetcher.new(current_user)
        }
        expose(:neurons) {
          neuron_scope.neurons
                      .includes(:contents)
        }
        expose(:neuron)
      end
    end
  end
end
