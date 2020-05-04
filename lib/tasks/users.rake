require "generate_users_task"

namespace :users do
  task set_ages: :environment do
    User.where(age: nil).find_each do |user|
      if user.birthday.present?
        user_age = (Date.today - user.birthday) / 365
        user.update! age: user_age.to_i
      end
    end
  end

  task set_birth_years: :environment do
    User.where(birth_year: nil).find_each do |user|
      if user.age.present?
        birth_year = Date.today.year - user.age
        user.birth_year = birth_year
        user.save validate: false
      end
    end
  end

  task set_usernames: :environment do
    User.where(username: nil).find_each do |user|
      username = "moi-" + user.email.parameterize + rand(1000).to_s
      user.update! username: username
    end
  end

  desc "usage: rake users:generate_users_from_list LIST_URI=https://goo.gl/azd2Ny"
  task generate_users_from_list: :environment do
    GenerateUsersTask.new(ENV["LIST_URI"]).run!
  end
end
