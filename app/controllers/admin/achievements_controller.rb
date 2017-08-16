module Admin
  class AchievementsController < AdminController::Base
    authorize_resource

    before_action :preload_settings!

    expose(:achievement, attributes: :achievement_params)

    expose(:decorated_achievement) {
      decorate achievement
    }

    expose(:achievement_categories) {
      [
        [I18n.t("views.achievements.settings.test"), "test"],
        [I18n.t("views.achievements.settings.content"), "content"]
      ]
    }

    expose(:achievement_aproved_contents) {
      [
        [I18n.t("views.achievements.settings.all"), "all"],
        [I18n.t("views.achievements.settings.personalized"), "personalized"]
      ]
    }

    expose(:selected_aproved_contents) {
      if achievement.settings["learn_all_contents"] == true
        result = "all"
      else
        result = "personalized"
      end
      result
    }

    expose(:selected_achievement_category) {
      achievement.category
    }

    def index
      @achievements = Achievement.all.order(created_at: :desc)
      render
    end

    def new
      render
    end

    def create
      achievement.settings = build_settings
      if achievement.save
        redirect_to admin_achievements_path, notice: I18n.t("views.achievements.created")
      else
        render :new
      end
    end

    def update
      achievement.settings = build_settings
      if achievement.save
        redirect_to admin_achievements_path, notice: I18n.t("views.achievements.updated")
      else
        render :edit
      end
    end

    private

    def build_settings
      category = params.require(:achievement_category)
      achievement.category = category
      settings = {}
      if achievement.category == "content"
        aproved_content = params.require(:achievement_aproved_content)
        if aproved_content == "all"
          settings["learn_all_contents"] = true
          settings["quantity"] = 0
        else
          settings["learn_all_contents"] = false
          settings["quantity"] = params.require(:achievement_content_number)
        end
      end

      if achievement.category == "test"
        settings["learn_all_contents"] = false
        settings["quantity"] = params.require(:achievement_test_number)
      end

      settings
    end

    def achievement_params

      params.require(:achievement).permit(
        :name,
        :description,
        :image
      )
    end

    def preload_settings!
      if achievement.settings.nil?
        achievement.settings = {}
        achievement.category = "test"
        achievement.settings["learn_all_contents"] = false
        achievement.settings["quantity"] = 1
      end
    end
  end
end
