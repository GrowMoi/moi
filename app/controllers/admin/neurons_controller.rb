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
          render json: neurons, meta: {root_id: Neuron.first.id}
        }
      end
    end

    def new
      self.neuron.parent_id = params[:parent_id]
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

    def update
      if neuron.save
        redirect_to admin_neurons_path, notice: I18n.t("views.neurons.updated")
      else
        render :edit
      end
    end

    private

    def neuron_params
      params.require(:neuron).permit :title,
                                      :parent_id
    end

    def resource
      @resource ||= neuron
    end
  end
end
