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

FactoryGirl.define do
  factory :room_chat do
    
  end

end
