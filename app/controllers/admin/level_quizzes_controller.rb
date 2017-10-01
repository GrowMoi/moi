module Admin
  class LevelQuizzesController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:level_quiz, attributes: :level_quiz_params)
    expose(:level_quizzes) {
      LevelQuiz.order(created_at: :desc)
    }

    expose(:contents) {
      Content.where(approved: true)
    }

    def new
      render
    end

    def show
      render
    end

    def create
      if level_quiz.save
        redirect_to admin_level_quizzes_path, notice: I18n.t("views.quizzes.created")
      else
        render :new
      end
    end

    private

    def level_quiz_params
      params.require(:level_quiz).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :name,
                  :description,
                  content_ids: []
                ]
    end

    def resource
      @resource ||= level_quiz.id
    end

  end
end
