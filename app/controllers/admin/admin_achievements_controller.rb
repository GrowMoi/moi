module Admin
  class AdminAchievementsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:admin_achievement, attributes: :admin_achievement_params)
    expose(:admin_achievements) {
      AdminAchievement.order(created_at: :desc)
    }

    expose(:neuron_selected) {
      Neuron.find(admin_achievement.settings["neuron_id"])
    }

    expose(:root_neuron) {
      Neuron.where(parent_id: nil, is_public: true, deleted: false, active: true).last
    }

    expose(:main_branches) {
      root_neuron.children_neurons.where(is_public: true, deleted: false, active: true)
    }

    expose(:neurons) {
      Neuron.published
    }

    def new
      admin_achievement
    end

    def create
      admin_achievement.category = 'neuron'
      add_json_params
      if admin_achievement.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def update
      add_json_params
      if admin_achievement.save
        redirect_to admin_admin_achievements_path, notice: I18n.t("views.achievements.updated")
      else
        render :edit
      end
    end

    private

    def add_json_params
      if admin_achievement.category === 'neuron'
        admin_achievement.settings = {
          quantity: params[:quantity],
          neuron_id: params[:neuron_id],
        }
      end
    end

    def admin_achievement_params
      params.require(:admin_achievement).permit(
        :name,
        :number,
        :description,
        :image
      )
    end

    def resource
      @resource ||= admin_achievement.id
    end
  end
end
