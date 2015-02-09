module Admin
  class NeuronsController < AdminController::Base
    include Breadcrumbs

    authorize_resource

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

    def tree_data
      respond_to do |format|
        format.json {
          parents = Neuron.where(parent_id: nil )
          scoped = parents.map do |neuron|
            neuron.to_node
          end
          render json: scoped
        }
      end
    end

    private

    def neuron_params
      params.require(:neuron).permit :title,
                                      :parent_id
    end
  end
end
