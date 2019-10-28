# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :string           default("cliente"), not null
#  uid                    :string           not null
#  provider               :string           default("email"), not null
#  tokens                 :json
#  birthday               :date
#  city                   :string
#  country                :string
#  tree_image             :string
#  school                 :string
#  username               :string
#  authorization_key      :string
#  age                    :integer
#  image                  :string
#  level                  :integer          default(1)
#  tree_image_app         :string
#  avatar                 :integer
#  gender                 :string
#

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user-#{n}@moi.org" }
    sequence(:password) { |n| "user-password-#{n}" }
    password_confirmation { password }

    role              "cliente"
    authorization_key "mock"

    # allows to have roles as user traits
    # example: create :user, :admin
    User.roles.each do |rol|
      trait rol.to_sym do
        role { rol }
      end
    end

    trait :with_username do
      sequence(:username) { |n| "user#{n}" }
    end

    trait :with_authorization_key do
      authorization_key :bananas
    end
  end
end
