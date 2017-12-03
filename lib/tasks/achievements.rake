achievements_params = [
  {
    name: "Contenidos aprendidos",
    description: "Han sido aprendidos los primeros 4 contenidos",
    category: "content",
    settings: {
      quantity: 4,
      branch: "any"
    },
    number: 1
  },
  {
    name: "Contenidos aprendidos rama Lenguaje",
    description: "Han sido aprendidos 20 contenidos de la rama Lenguaje",
    category: "content",
    settings: {
      quantity: 20,
      branch: "Lenguaje"
    },
    number: 2
  },
  {
    name: "Contenidos aprendidos rama Arte",
    description: "Han sido aprendidos 20 contenidos de la rama Arte",
    category: "content",
    settings: {
      quantity: 20,
      branch: "Arte"
    },
    number: 3
  },
  {
    name: "Contenidos aprendidos rama Contar",
    description: "Han sido aprendidos 20 contenidos de la rama Contar",
    category: "content",
    settings: {
      quantity: 20,
      branch: "Contar"
    },
    number: 4
  },
  {
    name: "Contenidos aprendidos rama Naturaleza",
    description: "Han sido aprendidos 20 contenidos de la rama Naturaleza",
    category: "content",
    settings: {
      quantity: 20,
      branch: "Naturaleza"
    },
    number: 5
  },
  {
    name: "Contenidos aprendidos en total",
    description: "Todos los contenidos han sido aprendidos",
    category: "content",
    settings: {
      quantity: "All",
      branch: "All"
    },
    number: 6
  },
  {
    name: "Contenidos aprendidos en cada neurona pública",
    description: "Al menos un contenido ha sido aprendido en cada neurona pública",
    category: "content",
    settings: {
      quantity: 1,
      branch: "All"
    },
    number: 7
  },
  {
    name: "Tests sin errores",
    description: "Han sido completados 4 test sin errores",
    category: "test",
    settings: {
      quantity: 4,
      continuous: true
    },
    number: 8
  },
  {
    name: "Tests desplegados",
    description: "Han sido desplegados 50 test sin errores",
    category: "test",
    settings: {
      quantity: 50,
      continuous: false
    },
    number: 9
  },
  {
    name: "Tiempo aprender contenidos",
    description: "Tiempo hasta el último contenido aprendido",
    category: "time",
    settings: {
      time: "any"
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
end
