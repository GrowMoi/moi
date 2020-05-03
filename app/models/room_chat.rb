# == Schema Information
#
# Table name: room_chats
#
#  id             :integer          not null, primary key
#  sender_id      :integer          not null
#  receiver_id    :integer          not null
#  sender_leave   :boolean          default(FALSE)
#  receiver_leave :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class RoomChat < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  has_many :user_chats, dependent: :destroy
end
