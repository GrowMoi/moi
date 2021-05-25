# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  kind       :string
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
  extend Enumerize

  after_create :schedule_generation!

  enumerize :kind,
            in: [:download_all_users_analytics]
  enumerize :status,
            in: [:new, :processed],
            default: :new
  validates :kind, presence: true

  def output_file
    Rails.root.join("public/#{uri}")
  end

  def uri
    # NB: XLS only for now
    name = "usuarios-mi-aula-bdp#{Time.now.strftime('-%m-%d-%Y')}"
    "reports/#{name}.xls"
  end

  private

  def schedule_generation!
    self.class.delay.generate_report!(id)
  end

  def self.generate_report!(id)
    resource = find(id)
    ReportGenerationWorker.new(resource).perform!
  end
end
