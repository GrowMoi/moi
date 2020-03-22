FactoryGirl.define do
  factory :user_chat do
    sender { build :user }
    receiver { build :user }
    sequence(:message) { |n| "ChatMessage #{n}" }
  end

end
