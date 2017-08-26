class CreateAchievements < ActiveRecord::Migration
  def up
    create_table :achievements do |t|
      t.string :name, null: false
      t.string :label, null: false
      t.text :description
      t.string :image
      t.string :category, null: false
      t.json :settings
      t.timestamps null: false
    end

    say_with_time "Create default achievements" do
        Achievement.create!(name: "Contenidos aprendidos en total",
                            label: "Contenidos aprendidos en total",
                            description: "",
                            category: "content_all",
                            settings: {
                              learn_all_contents: true,
                              quantity: nil
                            })
        Achievement.create!(name: "Contenidos aprendidos",
                            label: "Contenidos aprendidos",
                            description: "",
                            category: "content",
                            settings: {
                              learn_all_contents: false,
                              quantity: 50
                            })
        Achievement.create!(name: "Tests correctos",
                            label: "Tests resueltos correctamente",
                            description: "",
                            category: "test",
                            settings: {
                              learn_all_contents: false,
                              quantity: 10
                            })
        Achievement.create!(name: "Tiempo aprender contenidos",
                            label: "Tiempo hasta el último contenido aprendido",
                            description: "",
                            category: "time",
                            settings: {
                              learn_all_contents: false,
                              quantity: nil
                            })
    end

  end

  def down
    drop_table :achievements
  end
end
