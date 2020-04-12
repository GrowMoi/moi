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
#

class UserChat < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :sender_id,
            :receiver_id,
            :message,
            presence: true
end
