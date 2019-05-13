module Admin
  class EventAchievementsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:event, attributes: :event_achievements_params)
    expose(:events) {
      EventAchievement.order(created_at: :desc)
    }

    expose(:all_achievements) {
      AdminAchievement.all
    }

    expose(:achievements) {
      AdminAchievement.where(id: event.user_achievement_ids)
    }

    def create
      if event.save
        redirect_to admin_event_achievement_path(event), notice: I18n.t("views.events.created")
      else
        render :new
      end
    end

    def update
      if event.save
        redirect_to admin_event_achievement_path(event), notice: I18n.t("views.events.updated")
      else
        render :edit
      end
    end

    private

    def event_achievements_params
      params.require(:event_achievement).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :id,
                  :title,
                  :start_date,
                  :end_date,
                  :image,
                  :message,
                  :new_users,
                  user_achievement_ids: []
                ]
    end

    def resource
      @resource ||= event.id
    end

  end
end
