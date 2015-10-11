module Admin
  class NeuronsController < Neurons::BaseController
    before_action :add_breadcrumbs

    authorize_resource

    expose(:neurons) do
      if current_user.admin?
        Neuron.all
      else
        Neuron.not_deleted
      end
    end

    expose(:possible_parents) do
      # used by selects on forms
      scope = Neuron.select(:id, :title).order(:title)
      scope = scope.where.not(id: neuron.id) unless neuron.new_record?
      scope.map do |neuron|
        # format them for select
        [neuron.to_s, neuron.id]
      end
    end

    expose(:search_engines) do
      SearchEngine.active
    end

    expose(:initial_neurons) do
      TreeService::DepthFetcher.new(
        depth: 2
      ).neurons
    end

    expose(:root_neuron) do
      TreeService::RootFetcher.root_neuron
    end

    def index
      respond_to do |format|
        format.html
        format.json {
          render json: neurons, meta: {
            root_id: root_neuron.id,
            initial_tree: initial_neurons.map(&:id)
          }
        }
      end
    end

    def new
      neuron.parent_id = params[:parent_id]
    end

    def create
      if neuron.save_with_version
        redirect_to(
          { action: :show, id: neuron.id },
          notice: I18n.t("views.neurons.created")
        )
      else
        render :new
      end
    end

    def update
      if neuron.save_with_version
        redirect_to(
          { action: :show, id: neuron.id },
          notice: I18n.t("views.neurons.updated")
        )
      else
        render :edit
      end
    end

    def delete
      neuron.paper_trail_event = "delete"
      if neuron.update(deleted: true)
        redirect_to(
          { action: :index },
          notice: I18n.t("views.neurons.delete")
        )
      else
        redirect_to(
          { action: :index },
          error: I18n.t("activerecord.errors.messages.cannot_delete_neuron",
                        neuron: neuron)
        )
      end
    end

    def restore
      neuron.paper_trail_event = "restore"
      neuron.update! deleted: false
      redirect_to(
        { action: :index },
        notice: I18n.t("views.neurons.restore")
      )
    end
  end
end
