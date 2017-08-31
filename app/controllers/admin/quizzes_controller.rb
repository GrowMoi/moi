module Admin
  class QuizzesController < AdminController::Base

    authorize_resource

    expose(:quiz, attributes: :quiz_params)
    expose(:quizzes)

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
      allowed = [:level, :quizzes_attributes => [
                    :id,
                    :quiz_id,
                    :score,
                    :name
                  ]
                ]
    end
  end
end
