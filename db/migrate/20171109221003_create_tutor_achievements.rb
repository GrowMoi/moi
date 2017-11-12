class CreateTutorAchievements < ActiveRecord::Migration
  def change
    create_table :tutor_achievements do |t|
      t.references :user, index: true, null: false
      t.string :name, null: false
      t.text :description
      t.string :image
      t.timestamps null: false
    end
  end
end
