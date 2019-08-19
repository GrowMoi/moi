module AnalyticService
  class TestStatistic
    def initialize(user)
      @user = user
    end

    def results
      user_tests = ContentLearningTest.where(user: @user)
      user_tests.map do |test|
        questions_formated = test["questions"].map do |question|
          results_data = {
            content_id: question["content_id"],
            content_title: question["title"]
          }

          if test["answers"]
            answer = test["answers"].detect {|a| a["content_id"] == question["content_id"]}
            results_data[:correct] = answer && answer["correct"] ? answer["correct"] : nil
          else
            results_data[:correct] = nil
          end

          results_data
        end

        {
          test_id: test["id"],
          questions: questions_formated
        }
      end
    end
  end
end
