module Tutor
  class DashboardController < TutorController::Base

    expose(:tutor_achievements) {
      if (params[:search])
        TutorAchievementsSearch.new(q: params[:search], current_user: current_user).results
      else
        current_user.tutor_achievements
      end
    }

    expose(:tutor_achievement_selected) {
      if params[:id]
        TutorAchievement.find(params[:id])
      else
        TutorAchievement.new
      end
    }

    expose(:tutor_students) {
      if (params[:search])
        ids = current_user.tutor_requests_sent.accepted.select(:user_id).map(&:user_id)
        StudentsSearch.new(q: params[:search], ids: ids).results
      else
        current_user.tutor_requests_sent.accepted.map(&:user)
      end
    }

    expose(:tutor_achievement, attributes: :tutor_achievement_params)

    expose(:all_clients) {
      if params[:search]
        UserClientSearch.new(q:params[:search]).results
      else
        User.where(:role => :cliente)
      end
    }

    expose(:clients) {
      all_clients.where.not(
        id: tutor_students.map(&:id)
      ).page(params[:page])
    }

    def achievements
      render partial: "tutor/dashboard/lists/achievements_list"
    end

    def index
      render
    end

    def students
      render partial: "tutor/dashboard/lists/students_list"
    end

    def get_clients
      render partial: "tutor/dashboard/lists/clients_list"
    end

    def new_achievement
      if tutor_achievement.save!
        flash[:success] = I18n.t(
          "views.tutor.dashboard.achievement_request.created"
        )
        redirect_to :back
      else
        render nothing: true,
          status: :unprocessable_entity
      end
    end

    def edit_achievement
      render partial: "tutor/dashboard/dialogs/edit_achievement"
    end

    def update_achievement
      achievement = TutorAchievement.find(params[:id])
      if achievement.update(tutor_achievement_params)
        flash[:success] = I18n.t(
          "views.tutor.dashboard.achievement_request.updated"
        )
        redirect_to :back
      else
        render nothing: true,
          status: :unprocessable_entity
      end
    end

    def send_request
      tutor_request = current_user.tutor_requests_sent.new(
        user_id: params[:user_id]
      )
      if tutor_request.save
        flash[:success] = I18n.t(
          "views.tutor.moi.tutor_request.created",
          name: tutor_request.user.name
        )
      else
        flash[:error] = I18n.t(
          "views.tutor.moi.tutor_request.not_created",
          name: tutor_request.user.name
        )
      end
      render :js => "window.location = '/tutor/dashboard'"
    end

    private

    def tutor_achievement_params
      params.require(:tutor_achievement).permit(
        :name,
        :description,
        :image
      )
    end

  end
end
