# == Schema Information
#
# Table name: notification_links
#
#  id              :integer          not null, primary key
#  notification_id :integer          not null
#  link            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


class NotificationLink < ActiveRecord::Base
  belongs_to :notification
  validates :link, presence: true
  has_paper_trail ignore: [:created_at, :updated_at, :id]
end
