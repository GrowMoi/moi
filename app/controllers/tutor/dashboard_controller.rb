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
      if (params[:ids].present?)
        User.where(id:params[:ids], role: :cliente)
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

    expose(:contents) {
      Content.where(approved: true)
    }

    def achievements
      render json: {
        data: tutor_achievements
      }
    end

    def index
      render
    end

    def students
      render json: {
        data: tutor_students
      }
    end

    def get_clients
      render json: {
        data: clients,
        meta: {
          total_items: clients.total_count,
          total_pages: clients.total_pages
        }
      }
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
      flash[:success] = I18n.t(
        "views.tutor.dashboard.achievement_request.updated"
      )
      redirect_to :back
    end

    def get_contents
      render json: {
        data: contents
      }
    end

    def download_tutor_analytics
      @statistics_by_user = []
      tutor_students.each do |student|
          statistics = student.generate_statistics(
            [
              "total_neurons_learnt",
              "total_contents_learnt",
              "contents_learnt_by_branch",
              "used_time",
              "average_used_time_by_content",
              "images_opened_in_count",
              "total_notes",
              "user_test_answers",
              "content_learnings_with_reading_times"
            ]
          )

          @statistics_by_user.push({
            student: student,
            statistics: statistics
          })
      end

      respond_to do |format|
        format.html
        format.xls
      end
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
