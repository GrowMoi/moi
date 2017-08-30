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
        data["learn_all_contents"] = object.settings["learn_all_contents"] || false
        data["current_contents_learnt"] = scope.learned_contents.size
        data["needs_learn"] = object.settings["quantity"].to_i
      end

      if object.category == "content_all"
        data["total_contents"] = Content.joins(:neuron)
                                        .where(approved: :true, neurons: {is_public: true})
                                        .size
        data["learn_all_contents"] = object.settings["learn_all_contents"] || true
        data["current_contents_learnt"] = scope.learned_contents.size
      end

      if object.category == "time"
        user_content_learnings = ContentLearning.where(user: scope).order(created_at: :desc)
        if user_content_learnings.empty?
          data["exists_contents_learnt"] = false
        else
          data["exists_contents_learnt"] = true
          last_content_learnt = user_content_learnings.first
          time_diff = last_content_learnt.created_at - scope.created_at
          milliseconds = (time_diff.to_f.round(3)*1000).to_i
          data["time_elapsed"] = milliseconds
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
