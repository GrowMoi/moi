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
        awards: reward
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
      awards_by_test = reward_by(:test, &method(:build_test_award))
      awards_by_content = reward_by(:content, &method(:build_content_award))
      awards_by_test + awards_by_content
    end

    def reward_by(category, &callback)
      awards = Award.where(category: category)
      user_awards = []
      if awards.any?
        awards.each do |award|
          award_was_given = UserAward.where(user_id: current_user.id, award_id: award.id)
          if award_was_given.empty?
            user_awards = user_awards + callback.call(award)
          end
        end
      end
      user_awards
    end

    def build_test_award(award)
      items = []
      tests_aproved = award.settings["quantity"].to_i
      results = current_user.learning_tests
            .completed
            .limit(tests_aproved)
            .order(updated_at: :desc)
            .map(&:answers)
            .flatten()
            .map { |answer| answer["correct"] }
            .uniq
      enable_award = results.size == 1 && results[0] == true
      if enable_award
        formated_award = add_relation_format_award(award)
        items.push(formated_award) if formated_award
      end
      items
    end

    def build_content_award(award)
      items = []
      award_all_contents = award.settings["learn_all_contents"]
      award_custom_contents = award.settings["quantity"].to_i
      user_content_learnings = current_user.content_learnings.size

      if award_all_contents
        total_contents = Content.where(approved: false).size
        if total_contents == user_content_learnings
          formated_award = add_relation_format_award(award)
          items.push(formated_award)  if formated_award
        end
      end

      if award_custom_contents && (user_content_learnings >= award_custom_contents)
        formated_award = add_relation_format_award(award)
        items.push(formated_award)  if formated_award
      end

      items
    end

    def add_relation_format_award(award)
      relation = UserAward.new(user_id: current_user.id, award_id: award.id)
      if relation.save
        award_serialized = Api::AwardSerializer.new(award).as_json
        return award_serialized["award"]
      end
    end

  end
end
