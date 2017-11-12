# == Schema Information
#
# Table name: user_tutors
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  tutor_id   :integer          not null
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserTutor < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutor, class_name: "User"
  has_many :user_tutor_recommendations

  STATUSES = %w(accepted rejected).freeze

  validates :status, inclusion: { in: STATUSES }, allow_blank: true
  validate :unique_request_for_user, on: :create

  scope :pending, -> { where status: nil }
  scope :accepted, -> { where status: "accepted" }

  after_create :delayed_notify_user!

  private

  def delayed_notify_user!
    unless Rails.env.test?
      ##
      # only production server may be running background
      # workers. delay only for production
      if Rails.env.production?
        delay.send_pusher_notification!
      else
        send_pusher_notification!
      end
    end
  end

  def send_pusher_notification!
    user_channel = "usernotifications.#{user.id}"
    Pusher.trigger(user_channel, 'new-notification', {
      description: I18n.t(
        "views.tutor.moi.user_notification",
        tutor_name: tutor.name
      )
    })
  end

  def unique_request_for_user
    if self.class.where(user_id: user_id, tutor_id: tutor_id).exists?
      errors.add(:user_id, :invalid)
    end
  end
end
