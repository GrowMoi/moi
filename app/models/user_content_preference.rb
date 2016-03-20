class UserContentPreference < ActiveRecord::Base
  belongs_to :user
  validates :user,
            :kind,
            :level,
            presence: true
  validates :kind,
            inclusion: { in: Content::KINDS }
  validates :level,
            inclusion: { in: Content::LEVELS }

  def kind
    read_attribute(:kind).try :to_sym
  end
end
