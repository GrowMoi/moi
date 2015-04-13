module Admin
  module Neurons
    class BaseController < AdminController::Base
      include Breadcrumbs

      expose(:neuron, attributes: :neuron_params)
      alias_method :resource, :neuron

      expose(:decorated_neuron) {
        decorate neuron
      }

      expose(:formatted_contents) {
        neuron.build_contents!
        neuron.contents.inject({}) do |memo, content|
          memo[content.level] ||= Hash.new
          memo[content.level][content.kind] ||= Array.new
          memo[content.level][content.kind] << content
          memo
        end
      }

      private

      def breadcrumb_base
        "neuron"
      end

      def neuron_params
        params.require(:neuron)
              .permit :title,
                      :parent_id,
                      :contents_attributes => [
                        :id,
                        :kind,
                        :level,
                        :description,
                        :neuron_id,
                        :_destroy,
                        :keyword_list
                      ]
      end
    end
  end
end
