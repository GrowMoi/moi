module Admin
  class NeuronsController < AdminController::Base
    include Breadcrumbs

    authorize_resource

    expose(:neuron, attributes: :neuron_params)

    def create
      if neuron.save
        redirect_to(
          {action: :index},
          notice: I18n.t("views.neurons.created")
        )
      else
        render :new
      end
    end

    private

    def neuron_params
      params.require(:neuron).permit :title
    end
  end
end
