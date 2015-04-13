module Admin
  class NeuronsController < Neurons::BaseController
    before_action :add_breadcrumbs

    authorize_resource

    respond_to :html, :json

    expose(:neurons)

    expose(:possible_parents) {
      # used by selects on forms
      scope = Neuron.select(:id, :title).order(:title)
      unless neuron.new_record?
        scope = scope.where.not(id: neuron.id)
      end
      scope.map do |neuron|
        # format them for select
        [neuron.to_s, neuron.id]
      end
    }

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: neurons, meta: {root_id: Neuron.first.id}
        }
      end
    end

    def new
      neuron.parent_id = params[:parent_id]
    end

    def create
      if neuron.save_with_version
        redirect_to(
          {action: :index},
          notice: I18n.t("views.neurons.created")
        )
      else
        render :new
      end
    end

    def update
      if neuron.save_with_version
        redirect_to(
          {action: :index},
          notice: I18n.t("views.neurons.updated")
        )
      else
        render :edit
      end
    end
  end
end
