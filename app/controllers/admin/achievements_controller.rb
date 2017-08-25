module Admin
  class AchievementsController < AdminController::Base
    authorize_resource

    before_action :preload_settings!

    expose(:achievement, attributes: :achievement_params)

    expose(:decorated_achievement) {
      decorate achievement
    }

    expose(:learn_all_contents_status) {
      result = ""
      if achievement.settings["learn_all_contents"] == true
        result = "true"
      else
        result = "false"
      end
      result
    }

    expose(:learn_all_contents_value) {
      achievement.settings["learn_all_contents"]
    }

    expose(:achievement_categories) {
      [
        [I18n.t("views.achievements.settings.test"), "test"],
        [I18n.t("views.achievements.settings.content"), "content"],
        [I18n.t("views.achievements.settings.time"), "time"]
      ]
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
      category = params.require(:select_category)
      achievement.category = category
      settings = {}
      if achievement.category == "content"
        learn_all_contents = params.require(:check_box_learn_all_contents)
        if learn_all_contents == "true"
          settings["learn_all_contents"] = true
          settings["quantity"] = nil
        elsif learn_all_contents == "false"
          settings["learn_all_contents"] = false
          settings["quantity"] = params.require(:number_field_quantity)
        end
      end

      if achievement.category == "test"
        settings["learn_all_contents"] = false
        settings["quantity"] = params.require(:number_field_quantity)
      end

      if achievement.category == "time"
        settings["learn_all_contents"] = true
      end

      settings
    end

    def achievement_params

      params.require(:achievement).permit(
        :name,
        :label,
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
