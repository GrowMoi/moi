module Admin
  class NeuronsController < Neurons::BaseController
    include Breadcrumbs

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
    expose(:neuron_versions) {
      # decorate them
      decorate(
        neuron.versions.reverse,
        PaperTrail::NeuronVersionDecorator
      )
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

    private

    def breadcrumb_for_log
      breadcrumb_for "show"
      add_breadcrumb(
        I18n.t("views.neurons.show_changelog"),
        log_admin_neuron_path(resource)
      )
    end
  end
end
