module Admin
  class QuizzesController < AdminController::Base

    before_action :build_relationships!,
                  only: [:new]

    authorize_resource

    expose(:quiz, attributes: :quiz_params)
    expose(:quizzes)

    def new
      render
    end

    def create
      if quiz.save
        redirect_to admin_users_path, notice: I18n.t("views.users.created")
      else
        render :new
      end
    end

    def update
      if quiz.save
        redirect_to admin_users_path, notice: I18n.t("views.users.updated")
      else
        render :edit
      end
    end

    private

    def quiz_params
      params.require(:quiz).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :level,
                  :players_attributes => [
                    :id,
                    :name,
                    :_destroy
                  ]
                ]
    end

    def build_relationships!
      quiz.players.build
    end
  end
end
