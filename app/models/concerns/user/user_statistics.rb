class User < ActiveRecord::Base
  module UserStatistics

    def generate_statistics(fields = [])
      statistics = {}
      default_fields = [
        "total_notes",
        "user_sign_in_count",
        "user_created_at",
        "user_updated_at",
        "images_opened_in_count",
        "total_neurons_learnt",
        "user_tests",
        "total_content_readings",
        "content_readings_by_branch",
        "total_right_questions",
        "used_time"
      ]
      if fields.empty?
        default_fields.each do |field|
          statistics[field] = extract_statistic_by_field(field, statistics)
        end
      else
        fields.each do |field|
          statistic = extract_statistic_by_field(field, statistics)
          if (statistic.present?)
            statistics[field] = statistic
          end
        end
      end
      statistics
    end

    private

    def extract_statistic_by_field(field, statistics)
      result = nil
      if field.eql?("total_notes") then result = ContentNote.where(user: self).size end
      if field.eql?("user_sign_in_count") then result = self.sign_in_count end
      if field.eql?("user_created_at") then result = self.created_at end
      if field.eql?("user_updated_at") then result = self.updated_at end
      if field.eql?("images_opened_in_count") then result = UserSeenImage.where(user: self).size end
      if field.eql?("total_neurons_learnt") then result = TreeService::LearntNeuronsFetcher.new(self).ids.uniq.size end
      if field.eql?("user_tests") then result = AnalyticService::TestStatistic.new(self).results end
      if field.eql?("total_content_readings") then result = self.content_readings.size end
      if field.eql?("content_readings_by_branch") then result = AnalyticService::ContentReadingsByBranch.new(self).results end
      if field.eql?("total_right_questions") then result = AnalyticService::UtilsStatistic.new(self, statistics).total_right_questions end
      if field.eql?("used_time") then result = time_diff(self) end
      if field.eql?("average_used_time_by_content") then result = AnalyticService::UsedTimeByContent.new(self).average end
      return result
    end

    def time_diff(user)
      start_d = user.created_at
      end_d = user.updated_at
      time_diff = end_d - start_d
      milliseconds = (time_diff.to_f.round(3)*1000).to_i
      milliseconds
    end

  end
end
