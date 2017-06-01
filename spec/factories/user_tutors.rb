FactoryGirl.define do
  factory :user_tutor do
    user
    tutor { build :user }
  end
end
