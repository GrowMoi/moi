module Api
  class LearnController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user_test) {
      current_user.learning_tests
                  .uncompleted
                  .find(params[:test_id])
    }

    expose(:my_tutors) {
      UserTutor.where(user: current_user, status: :accepted)
    }

    expose(:my_recommendations) {
      ClientTutorRecommendation.where(client: current_user)
    }

    expose(:my_recommendations_in_progress) {
      my_recommendations.where(status: "in_progress").includes(:tutor_recommendation)
    }

    api :POST,
        "/learn",
        "answer a test and learn contents"
    param :test_id, Integer, required: true
    param :answers, String, required: true, desc: %{
needs to be a JSON-encoded string having the following format:


    [
      { "content_id": "2", "answer_id": "3" },
      { "content_id": "5", "answer_id": "8" },
      { "content_id": "9", "answer_id": "12" },
      { "content_id": "3", "answer_id": "15" }
    ]
    }
    def create
      answerer_result = answerer.result
      serialized_recommendations = []
      if is_client?(current_user)
        update_user_leaderboard
        serialized_recommendations = ActiveModel::ArraySerializer.new(
          update_recommendations,
          scope: current_user,
          each_serializer: Api::TutorRecommendationSerializer
        )

        serialized_achievements = ActiveModel::ArraySerializer.new(
          current_user.assign_achievements,
          scope: current_user,
          each_serializer: Api::UserAchievementSerializer
        )

        notification = create_test_completed_notification
        if notification
          my_tutors.each do |relation|
            notify_test_completed_to_tutor(relation.tutor_id, notification)
          end
        end
      end
      render json: {
        result: answerer_result,
        recommendations: serialized_recommendations,
        achievements: serialized_achievements
      }
    end

    private

    def answerer
      binding.pry
      TreeService::AnswerLearningTest.new(
        user_test: user_test,
        answers: JSON.parse(params[:answers])
      ).process!
    end

    def update_user_leaderboard
      time_elapsed = generate_time_elapsed
      user_leaderboard = Leaderboard.where(user: current_user).first
      if user_leaderboard.present?
        user_leaderboard.contents_learnt = current_user.content_learnings.size
        user_leaderboard.time_elapsed = time_elapsed
      else
        user_leaderboard = Leaderboard.new
        user_leaderboard.user_id = current_user.id
        user_leaderboard.contents_learnt = current_user.content_learnings.size
        user_leaderboard.time_elapsed = time_elapsed
      end
      user_leaderboard.save
    end

    def generate_time_elapsed
      user_content_learnings = ContentLearning.where(user: current_user).order(created_at: :desc)
      time_elapsed = 0
      if user_content_learnings.present?
        last_content_learnt = user_content_learnings.first
        time_diff = last_content_learnt.created_at - current_user.created_at
        milliseconds = (time_diff.to_f.round(3)*1000).to_i
        time_elapsed = milliseconds
      end
      time_elapsed
    end

    def is_client?(user)
      user.present? && user.cliente?
    end

    def update_recommendations
      recommendation_updated = []
      my_recommendations_in_progress.find_each do |client_tutor_recommendation|
        content_ids = client_tutor_recommendation.tutor_recommendation
                                                 .content_tutor_recommendations
                                                 .map(&:content_id)
        updated = TutorService::RecommendationsStatusUpdater.new(
          current_user,
          client_tutor_recommendation,
          content_ids
        ).perform
        if updated.present?
          recommendation_updated.push updated
        end
      end

      send_email_to_tutor(recommendation_updated)
      recommendation_updated
    end

    def send_email_to_tutor(recommendations)
      recommendations.each do |recommendation|
        tutor = recommendation.tutor_recommendation.tutor
        achievement = recommendation.tutor_recommendation.tutor_achievement
        TutorMailer.achievement_notification(tutor, current_user, achievement).deliver_now
      end
    end

    def notify_test_completed_to_tutor(tutor_id, notification_data)
      unless Rails.env.test?
        user_channel_general = "tutornotifications.#{tutor_id}"
        Pusher.trigger(user_channel_general, 'client-test-completed', notification_data)
      end
    end

    def create_test_completed_notification
      notification = ClientNotification.new
      notification.client_id = current_user.id
      notification.data_type = "client_test_completed"
      notification.data = {
        content_learning_test_id: user_test.id
      }
      return notification.save ? notification : nil;
    end

  end
end
