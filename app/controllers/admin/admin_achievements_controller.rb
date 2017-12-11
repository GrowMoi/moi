module Admin
  class AdminAchievementsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:admin_achievement, attributes: :admin_achievement_params)
    expose(:admin_achievements) {
      AdminAchievement.order(created_at: :desc)
    }

    def update
      if admin_achievement.save
        redirect_to admin_achievements_path, notice: I18n.t("views.achievements.updated")
      else
        render :edit
      end
    end

    private

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
