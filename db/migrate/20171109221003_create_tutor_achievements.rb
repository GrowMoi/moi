class CreateTutorAchievements < ActiveRecord::Migration
  def change
    create_table :tutor_achievements do |t|
      t.references :tutor, index: true, null: false
      t.string :name, null: false
      t.text :description
      t.string :image
      t.timestamps null: false
    end
    add_foreign_key :tutor_achievements, :users, column: :tutor_id
  end
end
