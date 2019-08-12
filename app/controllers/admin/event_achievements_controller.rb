module Admin
  class EventAchievementsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:event_achievement, attributes: :event_achievements_params)
    expose(:events) {
      EventAchievement.order(created_at: :desc)
    }

    expose(:decorated_event_achievement) {
      decorate event_achievement
    }

    expose(:all_achievements) {
      AdminAchievement.all
    }

    expose(:users_participants) {
      UserEventAchievement.where(event_achievement: event_achievement)
    }

    expose(:achievements) {
      AdminAchievement.where(id: event_achievement.user_achievement_ids)
    }

    def create
      if event_achievement.save
        redirect_to admin_event_achievement_path(event_achievement), notice: I18n.t("views.events.created")
      else
        render :new
      end
    end

    def update
      event_achievement_translated = TranslatableEditionEventAchievementService.new(
        event_achievement: event_achievement,
        params: params
      )
      if event_achievement_translated.save
        redirect_to admin_event_achievement_path(event_achievement, lang: params[:lang]), notice: I18n.t("views.events.updated")
      else
        render :edit
      end
    end

    def participants
      users_participants
    end

    private

    def event_achievements_params
      params.require(:event_achievement).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :id,
                  :title,
                  :description,
                  :start_date,
                  :end_date,
                  :image,
                  :inactive_image,
                  :message,
                  :new_users,
                  :email_notify,
                  :title_message,
                  :image_message,
                  :video_message,
                  user_achievement_ids: []
                ]
    end

    def resource
      @resource ||= event_achievement.id
    end

  end
end
