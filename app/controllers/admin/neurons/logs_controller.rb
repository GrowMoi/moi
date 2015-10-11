module Admin
  module Neurons
    class LogsController < BaseController
      before_action :add_breadcrumbs

      expose(:neuron_versions) do
        # decorate them
        decorate(
          neuron.versions.reverse,
          PaperTrail::NeuronVersionDecorator
        )
      end

      def show
        authorize! :log, neuron
      end

      private

      def breadcrumb_for_show
        add_breadcrumb(
          I18n.t("views.neurons.show_changelog"),
          admin_neuron_log_path(resource)
        )
      end
    end
  end
end
