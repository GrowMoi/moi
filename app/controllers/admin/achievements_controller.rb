module Admin
  class AchievementsController < AdminController::Base
    authorize_resource

    expose(:achievement, attributes: :achievement_params)

    expose(:achievement_categories) {
      [
        [I18n.t("views.achievements.form_new.settings_test"), "test"],
        [I18n.t("views.achievements.form_new.settings_content"), "content"]
      ]
    }

    expose(:achievement_aproved_contents) {
      [
        [I18n.t("views.achievements.form_new.settings_all"), "all"],
        [I18n.t("views.achievements.form_new.settings_personalized"), "personalized"]
      ]
    }

    def index
      @achievements = Achievement.all.order(created_at: :desc)
      render
    end

    def new
      render
    end

    def create
      category = params.require(:achievement_category)
      achievement.category = category
      settings = {}
      if achievement.category == "content"
        aproved_content = params.require(:achievement_aproved_content)
        if aproved_content == "all"
          settings["learn_all_contents"] = true
        else
          settings["learn_all_contents"] = false
          settings["quantity"] = params.require(:achievement_content_number)
        end
      end

      if achievement.category == "test"
        settings["learn_all_contents"] = false
        settings["quantity"] = params.require(:achievement_test_number)
      end

      achievement.settings = settings

      if achievement.save
        redirect_to admin_achievements_path
      else
        render :new
      end
    end

    private

    def achievement_params

      params.require(:achievement).permit(
        :name,
        :description,
        :image
      )
    end
  end
end
