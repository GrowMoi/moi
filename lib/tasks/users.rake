namespace :users do
  task set_ages: :environment do
    User.where(age: nil).find_each do |user|
      if user.birthday.present?
        user_age = (Date.today - user.birthday) / 365
        user.update! age: user_age.to_i
      end
    end
  end

  task set_usernames: :environment do
    User.where(username: nil).find_each do |user|
      username = "moi-" + user.email.parameterize + rand(1000).to_s
      user.update! username: username
    end
  end
end
