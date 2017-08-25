class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.string :label, null: false
      t.text :description
      t.string :image
      t.string :category, null: false
      t.json :settings
      t.timestamps null: false
    end
  end
end
