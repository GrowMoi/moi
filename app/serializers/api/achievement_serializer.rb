module Api
  class AchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :label,
        :description,
        :category,
        :meta

    def meta
      data = {}
      if object.category == "content"
        data["total_contents"] = Content.where(approved: :true).size
        learn_all = object.settings["learn_all_contents"]
        data["learn_all_contents"] = learn_all
        data["current_contents_learnt"] = scope.learned_contents.size

        if !learn_all
          data["needs_learn"] = object.settings["quantity"].to_i
        end

      end

      if object.category == "test"
        tests_to_approve = object.settings["quantity"].to_i
        tests = scope.learning_tests
            .completed
            .limit(tests_to_approve)
            .order(updated_at: :desc)
            .map(&:answers)

        test_ok_count = 0
        tests.each do |test|
          results = test.map { |answer| answer["correct"] }.uniq
          is_test_ok = results.size == 1 && results[0] == true
          if is_test_ok
            test_ok_count = test_ok_count + 1
          else
            break
          end
        end
        data["current_tests_ok"] = test_ok_count
        data["needs_tests_ok"] = tests_to_approve
      end

      data
    end
  end
end
