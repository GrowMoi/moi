# == Schema Information
#
# Table name: admin_achievements
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  description    :text
#  image          :string
#  category       :string
#  number         :integer
#  active         :boolean          default(TRUE)
#  settings       :json
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  inactive_image :string
#  requirement    :string
#

class AdminAchievement < ActiveRecord::Base
  include AssignAdminAchievement

  CATEGORIES = [
    'content',
    'branch',
    'test',
    'level',
    'neuron'
  ].freeze

  begin :enumerables
    enum categories: CATEGORIES
  end

  has_paper_trail ignore: [:created_at, :updated_at, :id]

  mount_uploader :image, ContentMediaUploader
  mount_uploader :inactive_image, ContentMediaUploader

  has_many :user_admin_achievements
  before_create :add_number

  begin :validations
    validates :name, :category, :settings,
              presence: true
    validates :number, uniqueness: true
    validates :category,
              inclusion: { in: CATEGORIES }
  end

  def add_number
    self.number = AdminAchievement.last.number + 1
  end

end
