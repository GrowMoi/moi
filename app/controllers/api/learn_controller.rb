module Api
  class LearnController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user_test) {
      current_user.learning_tests
                  .uncompleted
                  .find(params[:test_id])
    }

    expose(:active_events) {
      UserEvent.where(
        user: current_user,
        completed: false,
        expired: false
      )
    }

    expose(:user_event) {
      active_events.last
    }

    expose(:total_approved_contents) {
      Neuron.approved_public_contents.count
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
      serialized_achievements = []
      event_completed = nil
      event_is_completed = false
      # super event
      serialized_super_event = nil
      super_event_completed = false

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
      end

      if user_completed_any_event?
        event_completed = user_event.event
        event_is_completed = true
        serialized_event = EventCompleteSerializer.new(
          event_completed,
          scope: current_user,
          root: false
        )
      end

      unless current_user.reach_super_event.nil?
        super_event = current_user.my_super_events.last
        serialized_super_event = EventAchievementSerializer.new(
          super_event,
          scope: current_user
        )
        super_event_completed = true
      end

      render json: {
        result: answerer_result,
        recommendations: serialized_recommendations,
        achievements: serialized_achievements,
        event: {
          completed: event_is_completed,
          info: serialized_event
        },
        super_event: {
          completed: super_event_completed,
          info: serialized_super_event
        },
        meta: {
          current_learnt_contents: current_user.content_learnings.count,
          total_approved_contents: total_approved_contents
        }
      }
    end

    private

    def answerer
      TreeService::AnswerLearningTest.new(
        user_test: user_test,
        answers: JSON.parse(params[:answers]),
        active_events: active_events
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

      my_recommendations_in_progress = TutorService::RecommendationsHandler.new(
        current_user
      ).get_in_progress

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

      notify_tutor(recommendation_updated)
      recommendation_updated
    end

    def notify_tutor(recommendations)
      recommendations.each do |recommendation|
        tutor = recommendation.tutor_recommendation.tutor
        achievement = recommendation.tutor_recommendation.tutor_achievement
        TutorMailer.achievement_notification(tutor, current_user, achievement).deliver_now

        client_tutor_recommendation_id = recommendation.id
        client_notification = create_recommended_contents_completed_notification(client_tutor_recommendation_id)
        if client_notification
          notification_serialized = ClientNotificationSerializer.new(
            client_notification,
            root: false
          )
          notify_client_recommended_contents_completed_to_tutor(tutor.id, notification_serialized)
        end

      end
    end

    def create_recommended_contents_completed_notification(client_tutor_recommendation_id)
      notification = ClientNotification.new
      notification.client_id = current_user.id
      notification.data_type = "client_recommended_contents_completed"
      notification.data = {
        client_tutor_recommendation_id: client_tutor_recommendation_id
      }
      return notification.save ? notification : nil;
    end

    def notify_client_recommended_contents_completed_to_tutor(tutor_id, notification_data)
      unless Rails.env.test?
        user_channel_general = "tutornotifications.#{tutor_id}"
        begin
          Pusher.trigger(user_channel_general, 'client_recommended_contents_completed', notification_data)
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        else
          puts "PUSHER: Message sent successfully!"
          puts "PUSHER: #{notification_data}"
        end
      end
    end

    def user_completed_any_event?
      event_completed = false
      #check if completed
      if user_event
        totalContents = user_event.contents.count
        contentsLearnt = user_event.content_learning_events
        if totalContents == contentsLearnt.count
          contentsLearntIds = contentsLearnt.map(&:content_id)
          contentsLearntByTest = ContentLearning.where(
                                  content_id: contentsLearntIds,
                                  user: current_user
                                )
          if contentsLearnt.count == contentsLearntByTest.count
            user_event.completed = true
            user_event.save
            event_completed = true
          end
        end
      end
      event_completed
    end

  end
end
