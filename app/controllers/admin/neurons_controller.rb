module Admin
  class NeuronsController < Neurons::BaseController
    before_action :add_breadcrumbs

    authorize_resource

    expose(:neurons) {
      if current_user.admin?
        Neuron.all
      else
        Neuron.active
      end
    }

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

    expose(:search_engines) {
      SearchEngine.active
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
          {action: :show, id: neuron.id},
          notice: I18n.t("views.neurons.created")
        )
      else
        render :new
      end
    end

    def update
      if neuron.save_with_version
        redirect_to(
          {action: :show, id: neuron.id},
          notice: I18n.t("views.neurons.updated")
        )
      else
        render :edit
      end
    end

    def delete
      neuron.paper_trail_event = "delete"
      neuron.update! deleted: true
      redirect_to(
        {action: :index},
        notice: I18n.t("views.neurons.delete")
      )
    end

    def restore
      neuron.paper_trail_event = "restore"
      neuron.update! deleted: false
      redirect_to(
        {action: :index},
        notice: I18n.t("views.neurons.restore")
      )
    end
  end
end
