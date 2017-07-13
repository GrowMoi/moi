module Tutor
  class AnalysisController < TutorController::Base
    require 'time_diff'

    expose(:client_data) {
      User.where(id: params[:id], role: :cliente)
    }
    expose(:content_reading_times) {
      client_data.first.content_reading_times
    }
    expose(:reading_time_content_ids) {
      content_reading_times.select(:content_id)
                           .group(:content_id)
                           .pluck(:content_id)
    }
    expose(:grouped_reading_time_content_ids) {
      grouped = []
      ids_copy = reading_time_content_ids.dup
      while ids_copy.count > 0
        groups_of = 2 # in groups of 2 for the grid
        grouped.push ids_copy.slice!(0, groups_of)
      end
      grouped
    }

    def index
      if params[:search]
        @clients =  UserClientSearch.new(q:params[:search]).results
      else
        @clients = User.where(:role => :cliente)
      end
    end

    def show
      @client = client_data.first
      @statistics = @client.generate_statistics
      @statistics["total_right_questions"] = total_right_questions(@statistics["user_tests"])
      @statistics["used_time"] = time_diff(@statistics)
    end

    def total_right_questions(tests)
      count = 0
      tests.each do |test|
        test[:questions].each do |question|
          if question[:correct] === true
            count = count + 1
          end
        end
      end
      count
    end

    def time_diff(statistics)
      start_d = statistics["user_created_at"]
      end_d = statistics["user_updated_at"]
      diff_time = Time.diff(start_d, end_d)
      diff_time[:diff]
    end

    private

    def reading_time_for_content(content_id)
      content_reading_times.where(
        content_id: content_id
      ).sum(:time)
    end

    def show_content_title(id)
      Content.find(id).title
    end

    helper_method :reading_time_for_content
    helper_method :show_content_title
  end
end
