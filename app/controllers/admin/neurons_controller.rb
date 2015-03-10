module Admin
  class NeuronsController < AdminController::Base
    include Breadcrumbs

    authorize_resource

    respond_to :html, :json

    expose(:neurons)
    expose(:neuron, attributes: :neuron_params)
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
      decorate sorted_neuron_versions
    }
    expose(:content_versions) {
      decorate sorted_content_versions
    }
    expose(:sorted_neuron_versions) {
      paper_trail_order(neuron.versions)
    }
    expose(:sorted_content_versions) {
      paper_trail_order(neuron.versions_contents)
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

    expose(:decorated_neuron){
      decorate neuron
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
        redirect_to(
          {action: :index},
          notice: I18n.t("views.neurons.updated")
        )
      else
        render :edit
      end
    end

    private

    def neuron_params
      params.require(:neuron).permit :id,
                                      :title,
                                      :parent_id,
                                      :contents_attributes => [
                                        :id,
                                        :kind,
                                        :level,
                                        :description,
                                        :neuron_id,
                                        :_destroy
                                      ]
    end

    def resource
      @resource ||= neuron
    end

    def breadcrumb_for_log
      breadcrumb_for "show"
      add_breadcrumb(
        I18n.t("views.neurons.show_changelog"),
        log_admin_neuron_path(resource)
      )
    end

    def paper_trail_order(array)
      array.merge(
        PaperTrail::Version.unscope(:order)
      ).order(id: :desc)
    end
  end
end
