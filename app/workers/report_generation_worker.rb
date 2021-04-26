class ReportGenerationWorker
  include ApplicationHelper

  def initialize(report)
    @report = report
  end

  def perform!
    @statistics_by_user = []
    User.all.find_each do |student|
      statistics = student.generate_statistics(
        [
          "total_contents_learnt",
          "used_time",
          "user_created_at"
        ]
      )
      @statistics_by_user.push({
        student: student,
        statistics: statistics
      })
    end

    ##
    # make sure reports folder exists
    reports_path = Rails.root.join('public/reports')
    if !Dir.exist?(reports_path)
      Dir.mkdir(reports_path)
    end

    file = Rails.root.join(
      "app/views/tutor/dashboard/download_all_users_analytics.xls.erb"
    )
    xls = File.open(file).read
    template = ERB.new(xls)
    output_file = @report.output_file
    File.write(output_file, template.result(binding))
    @report.update!(status: :processed)
  end
end
