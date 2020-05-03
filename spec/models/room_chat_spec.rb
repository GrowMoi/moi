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

require 'rails_helper'

RSpec.describe RoomChat, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
