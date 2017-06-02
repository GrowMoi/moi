require "generate_random_users_task"

namespace :users do
  desc "generate random clients. rake users:generate_random_clients COUNT=5000"
  task generate_random_clients: :environment do
    GenerateRandomUsersTask.generate_random_clients!(
      ENV["COUNT"] || 10
    )
  end

  desc "generate random tutors. rake users:generate_random_tutors COUNT=300"
  task generate_random_tutors: :environment do
    GenerateRandomUsersTask.generate_random_tutors!(
      ENV["COUNT"] || 10
    )
  end
end
