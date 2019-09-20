module Tutor
  class DashboardController < TutorController::Base

    expose(:tutor_achievements) {
      current_user.tutor_achievements.order(created_at: :desc)
    }

    expose(:tutor_achievement_selected) {
      if params[:id]
        TutorAchievement.find(params[:id])
      else
        TutorAchievement.new
      end
    }

    expose(:level_quiz, attributes: :level_quiz_params)

    expose(:tutor_students) {
      if (params[:ids].present?)
        User.where(id:params[:ids], role: :cliente)
      else
        current_user.tutor_requests_sent.accepted.map(&:user)
      end
    }

    expose(:tutor_students_with_status_not_deleted) {
      if (params[:ids].present?)
        User.where(id:params[:ids], role: :cliente)
      else
        current_user.tutor_requests_sent.not_deleted.map(&:user)
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

    expose(:all_contents) {
      Neuron.approved_public_contents
    }

    expose(:student_ids) {
      tutor_students.map(&:id)
    }

    expose(:clients) {
      all_clients.where.not(
        id: tutor_students_with_status_not_deleted.map(&:id)
      ).page(params[:page])
    }

    expose(:unlearned_contents) {
      if params[:user_id]
        client = User.find(params[:user_id])
        unlearned = all_contents.where.not(
          id: client.content_learnings.map(&:content_id)
        )
        unlearned
      else
        all_contents
      end
    }

    expose(:questions) {
      if params[:content_ids]
        Content.where(id: params[:content_ids])
      else
        []
      end
    }

    expose(:level_quizzes) {
      LevelQuiz.order(created_at: :desc)
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
      render json: tutor_students_with_status_not_deleted,
      each_serializer: Tutor::DashboardStudentsSerializer,
      scope: current_user,
      root: "data"
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

    def get_level_quizzes
      render json: {
        data: level_quizzes
      }
    end

    def get_questions
      render json: {
        data: questions
      }
    end

    def new_achievement
      if tutor_achievement.save!
        flash[:success] = I18n.t(
          "views.tutor.dashboard.achievement_request.created"
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end

      redirect_to :back
    end

    def update_achievement
      achievement = TutorAchievement.find(params[:id])
      if achievement.update(tutor_achievement_params)
        flash[:success] = I18n.t(
          "views.tutor.dashboard.achievement_request.updated"
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end
      redirect_to :back
    end

    def get_contents
      render json: {
        data: unlearned_contents
      }
    end

    def level
      level_quiz.created_by = current_user.id
      if level_quiz.save
        render json: {
          data: level_quiz
        }
      else
        render json: {
          message: 'There was an error saving the Level',
        },
        status: 422
      end

    end

    def create_quiz

      send_to_all = quiz_params[:send_to_all]
      clients = []
      if send_to_all == "true"
        clients = tutor_students
      else
        clients = User.where(id: quiz_params[:client_id])
      end

      client_usernames = []
      clients.each do |client|
        quiz = Quiz.new
        player = Player.new
        level = LevelQuiz.find(quiz_params[:level_quiz_id])
        player.client_id = client.id
        player.name = client.name || client.username
        quiz.level_quiz = level
        quiz.created_by = current_user
        quiz.players.push(player)

        if quiz.save
          quiz_url = decorate(player).link_to_test
          Notification.create!(user: current_user,
                              title: "#{I18n.t('views.tutor.dashboard.quizzes.title')} #{Date.today.to_s}",
                              description: "#{I18n.t('views.tutor.dashboard.quizzes.available')}: #{quiz_url}",
                              data_type: "tutor_quiz",
                              client_id: client.id)

          client_usernames.push(client.username || client.email)
        end

        if client_usernames.any?
          flash[:success] = I18n.t(
            "views.tutor.dashboard.quizzes.created_all",
            client_usernames: client_usernames.join(", ")
          )
        else
          flash[:error] = I18n.t("views.tutor.common.error")
        end

      end

      render js: "window.location = '#{request.referrer}'"
    end

    def send_notification
      student_ids = []
      if send_to_all == "true"
        student_ids = tutor_students.map(&:id)
      else
        if student_ids_params.any?
          student_ids = student_ids_params
        else
          flash[:error] = I18n.t("views.tutor.common.error")
          return redirect_to :back
        end
      end

      all_status = []
      student_ids.each do |student_id|
        notification = Notification.new(notification_params)
        notification.user = current_user
        notification.client_id = student_id
        notification.data_type = "tutor_generic"
        saved = notification.save
        all_status.push(saved)
      end

      result = all_status.uniq
      if result.any? && result.size == 1 && result[0] == true
        flash[:success] = I18n.t(
          "views.tutor.dashboard.card_send_notifications.sent"
        )
      else
        flash[:error] = I18n.t("views.tutor.common.error")
      end

      redirect_to :back
    end

    def download_tutor_analytics
      @statistics_by_user = []
      @columns = params[:columns] || ["username", "total_neurons_learnt", "total_contents_learnt"]
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

    def notification_params
      params.require(:notification).permit(
        :title,
        :description,
        :notification_videos_attributes => [
          :url
        ],
        :notification_medium_attributes => [
          :media,
          :media_cache
        ]
      )
    end

    def student_ids_params
      params[:notification][:students] || []
    end

    def send_to_all
      params[:notification][:send_to_all] || "false"
    end

    def quiz_params
      params.require(:quiz).permit(*permitted_attributes)
    end

    def permitted_attributes
      [
        :level_quiz_id,
        :client_id,
        :send_to_all
      ]
    end

    def level_quiz_params
      params.require(:level_quiz).permit(*permitted_attributes_level_quiz)
    end

    def permitted_attributes_level_quiz
      [ :name,
        :description,
        content_ids: []
      ]
    end

  end
end
