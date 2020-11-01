class CreateUserImportings < ActiveRecord::Migration
  def change
    create_table :user_importings do |t|
      t.json :users, array: true, default: []
      t.timestamps null: false
    end
  end
end
