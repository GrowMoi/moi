# == Schema Information
#
# Table name: user_chats
#
#  id           :integer          not null, primary key
#  sender_id    :integer          not null
#  receiver_id  :integer          not null
#  message      :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  kind         :string           default("user"), not null
#  room_chat_id :integer
#

class UserChat < ActiveRecord::Base
  extend Enumerize

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :room_chat
  after_save :room_visible_for_sender_and_receiver

  validates :sender_id,
            :receiver_id,
            :message,
            :room_chat_id,
            presence: true

  enumerize :kind,
            in: [:user, :system],
            default: :user

  private

  def room_visible_for_sender_and_receiver
    if room_chat.sender_leave || room_chat.receiver_leave
      room_chat.sender_leave =  false
      room_chat.receiver_leave = false
      room_chat.save
    end
  end
end
