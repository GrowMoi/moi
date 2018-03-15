plans = [
  {
    name: "Básico"
  },
  {
    name: "Premium"
  }
]

namespace :plans do
  task create: :environment do
    plans_db = Plan.all.map(&:name)
    plans.each do |plan|
      unless plans_db.include?(plan[:name])
        Plan.create!(plan)
        puts "plan: #{plan[:name]}"
      end
    end
  end
end
