FactoryGirl.define do
  factory :user_content_preference do
    user
    kind { Content::KINDS.sample }
    level { Content::LEVELS.sample }
  end
end
