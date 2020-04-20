# == Schema Information
#
# Table name: user_chats
#
#  id          :integer          not null, primary key
#  sender_id   :integer          not null
#  receiver_id :integer          not null
#  message     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :string
#  kind        :string           default("user"), not null
#

class UserChat < ActiveRecord::Base
  extend Enumerize

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  before_create :create_room_id

  validates :sender_id,
            :receiver_id,
            :message,
            presence: true

  enumerize :kind,
            in: [:user, :system],
            default: :user

  private

  def create_room_id
    id = (self.receiver.created_at.to_f * 1000).to_i + (self.sender.created_at.to_f * 1000).to_i
    self.room_id = id
  end
end
