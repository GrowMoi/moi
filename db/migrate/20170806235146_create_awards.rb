class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name, null: false
      t.text :description
      t.string :image
      t.string :category, null: false
      t.json :settings
      t.timestamps null: false
    end
  end
end
