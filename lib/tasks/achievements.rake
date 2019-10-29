achievements_params = [
  {
    name: "Contenidos aprendidos",
    description: "Han sido aprendidos los primeros 4 contenidos",
    category: "content",
    settings: {
      quantity: 4,
      branch: "any",
      avatar: 1
    },
    number: 1
  },
  {
    name: "Contenidos aprendidos rama El verdadero valor del ahorro",
    description: "Han sido aprendidos 16 contenidos de la rama El verdadero valor del ahorro",
    category: "branch",
    settings: {
      quantity: 16,
      branch: "El verdadero valor del ahorro",
      avatar: 2
    },
    number: 2
  },
  # {
  #   name: "Contenidos aprendidos rama Arte",
  #   description: "Han sido aprendidos 20 contenidos de la rama Arte",
  #   category: "branch",
  #   settings: {
  #     quantity: 20,
  #     branch: "Arte"
  #   },
  #   number: 3
  # },
  {
    name: "Contenidos aprendidos rama La importancia del presupuesto",
    description: "Han sido aprendidos 16 contenidos de la rama La importancia del presupuesto",
    category: "branch",
    settings: {
      quantity: 16,
      branch: "La importancia del presupuesto",
      avatar: 3
    },
    number: 4
  },
  {
    name: "Contenidos aprendidos rama ¿Cuales son tus sueños? 2",
    description: "Han sido aprendidos 16 contenidos de la rama ¿Cuales son tus sueños? 2",
    category: "branch",
    settings: {
      quantity: 16,
      branch: "¿Cuales son tus sueños? 2",
      avatar: 4
    },
    number: 5
  },
  {
    name: "Contenidos aprendidos en total",
    description: "Todos los contenidos han sido aprendidos",
    category: "content",
    settings: {
      quantity: "All",
      branch: "All",
      avatar: 5
    },
    number: 6
  },
  {
    name: "Contenidos aprendidos en cada neurona pública",
    description: "Al menos un contenido ha sido aprendido en cada neurona pública",
    category: "content",
    settings: {
      quantity: 1,
      branch: "All",
      avatar: 6
    },
    number: 7
  },
  {
    name: "Tests sin errores",
    description: "Han sido completados 4 test sin errores",
    category: "test",
    settings: {
      quantity: 4,
      continuous: true,
      avatar: 7
    },
    number: 8
  },
  {
    name: "Tests desplegados",
    description: "Han sido desplegados 8 test",
    category: "test",
    settings: {
      quantity: 8,
      continuous: false,
      avatar: 8
    },
    number: 9
  },
  {
    name: "Final del Juego",
    description: "El usuario ha alcanzado el 5 nivel",
    category: "test",
    settings: {
      level: 5
    },
    number: 10
  }
]

namespace :achievements do
  task create: :environment do
    achievements_db_numbers = AdminAchievement.all.map(&:number)
    achievements_tasks = achievements_params
    achievements_tasks.each do |task_params|
      unless achievements_db_numbers.include?(task_params[:number])
        AdminAchievement.create!(task_params)
        puts "created: #{task_params[:name]}"
      end
    end
  end

  task update: :environment do
    achievements_db = AdminAchievement.all.map(&:number)
    achievements_params.each do |achievement|
      if achievements_db.include?(achievement[:number])
        achievement_db = AdminAchievement.find_by_number(achievement[:number])
        achievement_db.update(achievement)
        puts "AdminAchievement updated: #{achievement[:name]}"
      end
    end
  end

  #assign achievements just for active users
  task set_user_achievements: :environment do
    clients_ids = ContentLearning.all.map(&:user_id).uniq.sort
    clients = User.where(id: clients_ids)
    achievements_db = AdminAchievement.all
    clients.each do |client|
      my_achievements = client.user_admin_achievements.map(&:admin_achievement_id)
      no_achievements = achievements_db.reject{ |x| my_achievements.include? x.id }
      assign_achievement(no_achievements, client)
    end
  end
end


def assign_achievement(achievements, user)
  achievements.each do |achievement|
    if achievement.user_win_achievement?(user)
      UserAdminAchievement.create!(user_id: user.id, admin_achievement_id: achievement.id)
      puts "user: #{user.name}, user_id: #{user.id}, achievement assign: #{achievement.name}"
    end
  end
end
