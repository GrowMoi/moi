module Admin
  class NeuronsController < AdminController::Base
    include Breadcrumbs

    authorize_resource

    respond_to :html, :json

    expose(:neuron, attributes: :neuron_params)
    expose(:possible_parents) {
      # used by selects on forms
      scope = Neuron.select(:id, :title)
      unless neuron.new_record?
        scope = scope.where.not(id: neuron.id)
      end
      scope.map do |neuron|
        # format them for select
        [neuron.to_s, neuron.id]
      end
    }
    expose(:neurons)

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: neurons, meta: {root_id: 1}
        }
      end
    end

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
      params.require(:neuron).permit :title,
                                      :parent_id
    end
  end
end
