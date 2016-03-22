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

  ##
  # @param [String] kind
  # @raise [ActiveRecord::NotFound] if provided
  #   kind doesn't exist
  scope :by_kind, ->(kind) do
    find_by!(kind: kind)
  end

  def kind
    read_attribute(:kind).try :to_sym
  end
end
