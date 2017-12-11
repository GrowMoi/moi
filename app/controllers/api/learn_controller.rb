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
        update_user_test_achievement
        update_user_leaderboard
        serialized_recommendations = ActiveModel::ArraySerializer.new(
          update_recommendations,
          scope: current_user,
          each_serializer: Api::TutorRecommendationSerializer
        )
      end

      render json: {
        result: answerer_result,
        recommendations: serialized_recommendations
      }
    end

    private

    def answerer
      TreeService::AnswerLearningTest.new(
        user_test: user_test,
        answers: JSON.parse(params[:answers])
      ).process!
    end

    def update_user_test_achievement
      test_achievement = Achievement.where(category: :test).first
      user_test_achievement = UserAchievement.where(
        user_id: current_user.id,
        achievement_id: test_achievement.id
      ).first
      if user_test_achievement.present?
        update_tests_ok(user_test_achievement)
      else
        create_relation_user_achievement(test_achievement)
      end
    end

    def update_tests_ok(user_test_achievement)
      last_max_test_value = user_test_achievement.meta["max_tests_ok"] || 0
      new_max_test_value = last_max_test_value + 1
      last_learning_tests = get_tests_results(new_max_test_value)
      result = last_learning_tests.size == 1 && last_learning_tests[0] == true
      if result
        user_test_achievement.meta["max_tests_ok"] = new_max_test_value
        user_test_achievement.save
      end
    end

    def create_relation_user_achievement(test_achievement)
      user_achievement = UserAchievement.new
      user_achievement.user_id = current_user.id
      user_achievement.achievement_id = test_achievement.id
      last_learning_tests = get_total_tests_results
      value = get_max_tests_ok(last_learning_tests)
      user_achievement.meta = {
        max_tests_ok: value
      }
      user_achievement.save
    end

    def get_tests_results(max_test_value)
      current_user.learning_tests
                  .completed
                  .limit(max_test_value)
                  .order(updated_at: :desc)
                  .map { |test|
                    is_test_correct(test)
                  }.uniq
    end

    def get_total_tests_results
      current_user.learning_tests
                  .completed
                  .order(updated_at: :desc)
                  .map do |test|
                    is_test_correct(test)
                  end
    end

    def get_max_tests_ok(test_results)
      count = 0
      result = []
      test_results.each_with_index  do |test_value, index|
        if test_value === true
          count = count + 1
          if index == test_results.size - 1
            result.push(count)
          end
        else
          if count > 0
            result.push(count)
          end
          count = 0
        end
      end
      result.max || 0
    end

    def is_test_correct(test)
      is_correct = false
      if test["answers"].present?
        correct_answers = test["answers"].map { |a|a["correct"]}.uniq
        is_correct = correct_answers.size == 1 && correct_answers[0] == true
      end
      is_correct
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
      user_tutors = UserTutor.where(user: current_user)
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
