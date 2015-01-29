FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@moi.org" }
    sequence(:password) { |n| "user-password-#{n}" }
  end

end
