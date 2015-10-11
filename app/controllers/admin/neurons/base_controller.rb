module Admin
  module Neurons
    class BaseController < AdminController::Base
      include Breadcrumbs

      expose(:neuron, attributes: :neuron_params)
      alias_method :resource, :neuron

      expose(:decorated_neuron) do
        decorate neuron
      end

      expose(:formatted_contents) do
        neuron.build_contents!
        neuron.contents.inject({}) do |memo, content|
          memo[content.level] ||= {}
          memo[content.level][content.kind] ||= []
          content.build_possible_answers!
          memo[content.level][content.kind] << decorate(content)
          memo
        end
      end

      private

      def breadcrumb_base
        "neuron"
      end

      def neuron_params
        params.require(:neuron)
          .permit :id,
                  :title,
                  :parent_id,
                  :is_public,
                  contents_attributes: [
                    :id,
                    :kind,
                    :level,
                    :title,
                    :description,
                    :neuron_id,
                    :_destroy,
                    :keyword_list,
                    :source,
                    :media,
                    :media_cache,
                    possible_answers_attributes: [
                      :correct,
                      :text
                    ]
                  ]
      rescue ActionController::ParameterMissing
        {}
      end
    end
  end
end
