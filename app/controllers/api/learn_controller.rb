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
      update_user_test_achievement
      render json: {
        result: answerer_result
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
      last_max_test_value = user_test_achievement.meta["max_tests_ok"] || 0
      new_max_test_value = last_max_test_value + 1
      last_learning_tests = current_user.learning_tests
              .completed
              .limit(new_max_test_value)
              .order(updated_at: :desc)
              .map { |test|
                correct_answers = test["answers"].map { |a|
                  a["correct"]
                }.uniq
                correct_answers.size == 1 && correct_answers[0] == true
              }.uniq

      result = last_learning_tests.size == 1 && last_learning_tests[0] == true

      if result
        user_test_achievement.meta["max_tests_ok"] = new_max_test_value
        user_test_achievement.save
      end

    end

  end
end
