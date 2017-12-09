module Api
  class LearnController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user_test) {
      current_user.learning_tests
                  .uncompleted
                  .find(params[:test_id])
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
          current_user.user_admin_achievements,
          scope: current_user,
          each_serializer: Api::UserAchievementSerializer
        )

      end
      render json: {
        result: answerer_result,
        recommendations: serialized_recommendations,
        achievements: serialized_achievements
      }
    end

    private

    def answerer
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
      user_tutors = UserTutor.where(user: current_user, status: :accepted)
      recommendations = []
      user_tutors.find_each do |user_tutor|
        tutor = user_tutor.tutor
        recommendations_updated = TutorService::RecommendationsUpdater.new(current_user, tutor).update
        recommendations.concat recommendations_updated
      end
      notify_tutor(recommendations)
      recommendations
    end

    def notify_tutor(recommendations)
      recommendations.each do |recommendation|
        tutor = recommendation.tutor_recommendation.tutor
        achievement = recommendation.tutor_recommendation.tutor_achievement
        TutorMailer.achievement_notification(tutor, current_user, achievement).deliver_now
      end
    end

  end
end
