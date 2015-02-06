FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@moi.org" }
    sequence(:password) { |n| "user-password-#{n}" }
    password_confirmation { password }
    role "cliente"

    # allows to have roles as user traits
    # example: create :user, :admin
    User::Roles::ROLES.each do |rol|
      trait rol.to_sym do
        role { rol }
      end
    end
  end
end
