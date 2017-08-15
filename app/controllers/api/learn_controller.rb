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
      render json: {
        result: answerer.result,
        achievements: reward
      }
    end

    private

    def answerer
      TreeService::AnswerLearningTest.new(
        user_test: user_test,
        answers: JSON.parse(params[:answers])
      ).process!
    end

    def reward
      achievements_by_test = reward_by(:test, &method(:build_test_achievement))
      achievements_by_content = reward_by(:content, &method(:build_content_achievement))
      achievements_by_test + achievements_by_content
    end

    def reward_by(category, &callback)
      achievements = Achievement.where(category: category)
      user_achievements = []
      if achievements.any?
        achievements.each do |achievement|
          achievement_was_given = UserAchievement.where(user_id: current_user.id, achievement_id: achievement.id)
          if achievement_was_given.empty?
            user_achievements = user_achievements + callback.call(achievement)
          end
        end
      end
      user_achievements
    end

    def build_test_achievement(achievement)
      items = []
      tests_aproved = achievement.settings["quantity"].to_i
      results = current_user.learning_tests
            .completed
            .limit(tests_aproved)
            .order(updated_at: :desc)
            .map(&:answers)
            .flatten()
            .map { |answer| answer["correct"] }
            .uniq
      enable_achievement = results.size == 1 && results[0] == true
      if enable_achievement
        formated_achievement = add_relation_format_achievement(achievement)
        items.push(formated_achievement) if formated_achievement
      end
      items
    end

    def build_content_achievement(achievement)
      items = []
      achievement_all_contents = achievement.settings["learn_all_contents"]
      achievement_custom_contents = achievement.settings["quantity"].to_i
      user_content_learnings = current_user.content_learnings.size

      if achievement_all_contents
        total_contents = Content.where(approved: :true).size
        if total_contents == user_content_learnings
          formated_achievement = add_relation_format_achievement(achievement)
          items.push(formated_achievement)  if formated_achievement
        end
      end

      if achievement_custom_contents && (user_content_learnings >= achievement_custom_contents)
        formated_achievement = add_relation_format_achievement(achievement)
        items.push(formated_achievement)  if formated_achievement
      end

      items
    end

    def add_relation_format_achievement(achievement)
      relation = UserAchievement.new(user_id: current_user.id, achievement_id: achievement.id)
      if relation.save
        achievement_serialized = Api::AchievementSerializer.new(achievement).as_json
        return achievement_serialized["achievement"]
      end
    end

  end
end
