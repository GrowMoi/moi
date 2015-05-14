module DashboardHelper
  ##
  # Creates tabs for different neuron states
  #
  # @param states [Array] neuron states to display
  # @return [String] tabs for neuron states
  def neuron_tabs(*states)
    content_tag :ul, class: "nav nav-tabs" do
      states.map do |state|
        active_class = "active" if neurons_state == state.to_s
        content_tag :li, class: active_class do
          link_to t("views.neurons.#{state}"), state: state
        end
      end.join.html_safe
    end
  end
end
