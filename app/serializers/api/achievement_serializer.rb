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
        test_achievement = Achievement.where(category: :test).first
        user_test_achievement = UserAchievement.where(
          user_id: scope.id,
          achievement_id: test_achievement.id
        ).first

        data["current_tests_ok"] = 0

        if user_test_achievement.present?
          data["current_tests_ok"] = user_test_achievement.meta["max_tests_ok"]
        end

      end

      data
    end
  end
end
