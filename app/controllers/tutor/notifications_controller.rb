module Tutor
  class NotificationsController < TutorController::Base

    expose(:tutor_students) {
      current_user.tutor_requests_sent.accepted.map(&:user)
    }

    expose(:player) {
      player_id = (client_notification.data.any? && client_notification.data["player_id"]) ?
                  client_notification.data["player_id"] : nil

      if player_id
        Player.find(player_id)
      else
        nil
      end
    }

    expose(:player_test) {
      player.learning_quiz
    }

    expose(:student_ids) {
      tutor_students.map(&:id)
    }

    expose(:client_notifications) {
      ClientNotification.where(client: student_ids, deleted: false)
    }

    expose(:client_notification) {
      ClientNotification.find(params[:id])
    }

    def index
      render
    end

    def info
      render json: client_notifications,
      each_serializer: Api::ClientNotificationSerializer,
      root: "data"
    end

    def details
      type = client_notification.data_type
      if type == "client_test_completed"
        if !player.present?
          return render json: {
            message: 'Player not found',
          },
          status: 422
        end

        render json: {
          quiz_id: player.quiz_id,
          player_name: player.name,
          player_id: player.id,
          questions: quiz_fetcher.player_test_for_api,
          answers: player_test.answers,
          time: timeQuiz
        }
      else
        render json: {}
      end
    end

    private

    def quiz_fetcher
      TreeService::QuizFetcher.new(
        player
      )
    end


    def timeQuiz
      time_diff = player_test.updated_at - player_test.created_at
      Time.at(time_diff).utc.strftime("%H :%M :%S")
    end

  end
end
