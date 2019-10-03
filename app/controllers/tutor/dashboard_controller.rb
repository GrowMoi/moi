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

    def download_tutor_analytics_v2
      @statistics_by_user = []
      @columns = params[:columns] || [
        "username",
        "total_neurons_learnt",
        "total_contents_learnt"
      ]
      usernames = params[:usernames] || []

      User.where(username: usernames).each do |student|
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

    def download_tutor_analytics_v3
      @statistics_by_user = []
      @columns = params[:columns] || [
        "total_neurons_learnt",
        "total_contents_learnt"
      ]
      usernames = params[:usernames] || []

      User.where(username: usernames).each do |student|
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

      @root_url = /[^:\/?#]+:?\/\/[^\/?#]*/.match(request.url) || "";

      sort_fields = ["username", "email"]
      sort_by = sort_fields.include?(params[:sort_by]) ? params[:sort_by] : "username"
      @statistics_by_user.sort_by!{ |item| item[:student][sort_by].downcase }

      respond_to do |format|
        format.html
        format.xlsx do
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(name: "Estudiantes") do |sheet|
            sheet.add_row report_labels
            @statistics_by_user.each do |statistics|
              sheet.add_row report_fields(statistics)
            end
            sheet.add_chart(Axlsx::Pie3DChart, start_at: "A#{@statistics_by_user.count + 6}", end_at: "E#{@statistics_by_user.count + 26}") do |chart|
              chart.add_series data: sheet["D2:D#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Contenidos aprendidos en total"
            end
            sheet.add_chart(Axlsx::Pie3DChart, start_at: "F#{@statistics_by_user.count + 6}", end_at: "I#{@statistics_by_user.count + 26}") do |chart|
              chart.add_series data: sheet["E2:E#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Contenidos aprendidos neurona #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][0][:title]}"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "J#{@statistics_by_user.count + 6}", end_at: "M#{@statistics_by_user.count + 26}") do |chart|
              chart.add_series data: sheet["F2:F#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Contenidos aprendidos neurona #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][1][:title]}"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "N#{@statistics_by_user.count + 6}", end_at: "R#{@statistics_by_user.count + 26}") do |chart|
              chart.add_series data: sheet["G2:G#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Contenidos aprendidos neurona #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][2][:title]}"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "A#{@statistics_by_user.count + 30}", end_at: "E#{@statistics_by_user.count + 50}") do |chart|
              chart.add_series data: sheet["H2:H#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Contenidos aprendidos neurona #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][3][:title]}"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "F#{@statistics_by_user.count + 30}", end_at: "I#{@statistics_by_user.count + 50}") do |chart|
              chart.add_series data: sheet["I2:I#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Neuronas aprendidas"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "J#{@statistics_by_user.count + 30}", end_at: "M#{@statistics_by_user.count + 50}") do |chart|
              chart.add_series data: sheet["K2:K#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Tiempo de uso"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "N#{@statistics_by_user.count + 30}", end_at: "R#{@statistics_by_user.count + 50}") do |chart|
              chart.add_series data: sheet["M2:M#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Tiempo de lectura promedio"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "A#{@statistics_by_user.count + 54}", end_at: "E#{@statistics_by_user.count + 74}") do |chart|
              chart.add_series data: sheet["N2:N#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Imagenes abiertas"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "F#{@statistics_by_user.count + 54}", end_at: "I#{@statistics_by_user.count + 74}") do |chart|
              chart.add_series data: sheet["O2:O#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Notas agregadas"
            end

            sheet.add_chart(Axlsx::Pie3DChart, start_at: "J#{@statistics_by_user.count + 54}", end_at: "M#{@statistics_by_user.count + 74}") do |chart|
              chart.add_series data: sheet["P2:P#{@statistics_by_user.count + 1}"],
                   labels: sheet["A2:A#{@statistics_by_user.count + 1}"],
                   title: "Logros alcanzados"
            end

          end
          send_data p.to_stream.read, type: "application/xlsx"
        end
      end
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

    def report_labels
      result = ["Usuario"]

      if @columns.include?("name")
        result.push("Nombre")
      end

      if @columns.include?("email")
        result.push("Email")
      end

      if @columns.include?("total_contents_learnt")
        result.push("Contenidos aprendidos en total")
      end

      if @columns.include?("contents_learnt_branch_aprender")
        result.push("Contenidos aprendidos en rama #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][0][:title]}")
      end

      if @columns.include?("contents_learnt_branch_artes")
        result.push("Contenidos aprendidos en rama #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][1][:title]}")
      end

      if @columns.include?("contents_learnt_branch_lenguaje")
        result.push("Contenidos aprendidos en rama #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][2][:title]}")
      end

      if @columns.include?("contents_learnt_branch_naturaleza")
        result.push("Contenidos aprendidos en rama #{@statistics_by_user[0][:statistics]["contents_learnt_by_branch"][:value][3][:title]}")
      end

      if @columns.include?("total_neurons_learnt")
        result.push("Neuronas aprendidas")
      end

      if @columns.include?("used_time")
        result.push("Tiempo de uso")
      end

      if @columns.include?("used_time_ms")
        result.push("Tiempo de uso en milisegundos")
      end

      if @columns.include?("average_reading_time")
        result.push("Tiempo de lectura promedio")
      end

      if @columns.include?("average_reading_time_ms")
        result.push("Tiempo de lectura promedio en milisegundos")
      end

      if @columns.include?("images_opened_in_count")
        result.push("Imagenes abiertas")
      end

      if @columns.include?("total_notes")
        result.push("Notas agregadas")
      end

      result.push("Logros alcanzados")

      if @columns.include?("link_analysis")
        result.push("Enlace a vista de analisis")
      end

      result
    end

    def report_fields(statistics)
      result = [statistics[:student].username]

      if @columns.include?("name")
        result.push(statistics[:student].name)
      end

      if @columns.include?("email")
        result.push(statistics[:student].email)
      end

      if @columns.include?("total_contents_learnt")
        result.push(statistics[:statistics]["total_contents_learnt"][:value])
      end

      if @columns.include?("contents_learnt_branch_aprender")
        result.push(statistics[:statistics]["contents_learnt_by_branch"][:value][0][:total_contents_learnt])
      end

      if @columns.include?("contents_learnt_branch_artes")
        result.push(statistics[:statistics]["contents_learnt_by_branch"][:value][1][:total_contents_learnt])
      end

      if @columns.include?("contents_learnt_branch_lenguaje")
        result.push(statistics[:statistics]["contents_learnt_by_branch"][:value][2][:total_contents_learnt])
      end

      if @columns.include?("contents_learnt_branch_naturaleza")
        result.push(statistics[:statistics]["contents_learnt_by_branch"][:value][3][:total_contents_learnt])
      end

      if @columns.include?("total_neurons_learnt")
        result.push(statistics[:statistics]["total_neurons_learnt"][:value])
      end

      if @columns.include?("used_time")
        result.push(statistics[:statistics]["used_time"][:meta][:value_humanized])
      end

      if @columns.include?("used_time_ms")
        result.push(statistics[:statistics]["used_time"][:value])
      end

      if @columns.include?("average_reading_time")
        result.push(statistics[:statistics]["average_used_time_by_content"][:meta][:value_humanized])
      end

      if @columns.include?("average_reading_time_ms")
        result.push(statistics[:statistics]["average_used_time_by_content"][:value])
      end

      if @columns.include?("images_opened_in_count")
        result.push(statistics[:statistics]["images_opened_in_count"][:value])
      end

      if @columns.include?("total_notes")
        result.push(statistics[:statistics]["total_notes"][:value])
      end

      result.push(statistics[:student].my_achievements.count || 0)

      if @columns.include?("link_analysis")
        result.push("#{@root_url}/tutor/analysis?client_id=#{statistics[:student].id}")
      end

      result
    end

  end
end
