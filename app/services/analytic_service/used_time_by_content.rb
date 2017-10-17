module AnalyticService
  class UsedTimeByContent
    def initialize(user)
      @user = user
    end

    def average
      times = group_contents || {}
      result = if times.values.empty? then 0 else calculate_mean(times) end
      result
    end

    private

    def get_content_reading_times
      @user.content_reading_times
    end

    def calculate_mean(times)
      times.values.reduce(:+) / times.size
    end

    def group_contents
      content_reading_times = get_content_reading_times || []
      content_reading_times.select(:content_id, :time)
                          .group(:content_id)
                          .sum(:time)
    end
  end
end
