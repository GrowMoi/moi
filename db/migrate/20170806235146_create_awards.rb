class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.text :description
      t.string :image
      t.json :settings
      t.timestamps null: false
    end
  end
end
