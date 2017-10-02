class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.float :score
      t.references :quiz, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
