module Admin
  class AwardsController < AdminController::Base
    authorize_resource

    expose(:award, attributes: :award_params)

    expose(:award_categories) {
      [
        [I18n.t("views.awards.form_new.settings_test"), "test"],
        [I18n.t("views.awards.form_new.settings_content"), "content"]
      ]
    }

    expose(:award_aproved_contents) {
      [
        [I18n.t("views.awards.form_new.settings_all"), "all"],
        [I18n.t("views.awards.form_new.settings_personalized"), "personalized"]
      ]
    }

    def index
      @awards = Award.all.order(created_at: :desc)
      render
    end

    def new
      render
    end

    def create
      category = params.require(:award_category)
      award.category = category
      settings = {}
      if award.category == "content"
        aproved_content = params.require(:award_aproved_content)
        if aproved_content == "all"
          settings["learn_all_contents"] = true
        else
          settings["learn_all_contents"] = false
          settings["quantity"] = params.require(:award_content_number)
        end
      end

      if award.category == "test"
        settings["learn_all_contents"] = false
        settings["quantity"] = params.require(:award_question_number)
      end

      award.settings = settings

      if award.save
        redirect_to admin_awards_path
      else
        render :new
      end
    end

    private

    def award_params

      params.require(:award).permit(
        :name,
        :description,
        :image
      )
    end
  end
end
