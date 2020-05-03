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

FactoryGirl.define do
  factory :user_chat do
    sender { build :user }
    receiver { build :user }
    sequence(:message) { |n| "ChatMessage #{n}" }
  end

end
