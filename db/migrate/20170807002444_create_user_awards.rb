class CreateUserAwards < ActiveRecord::Migration
  def change
    create_table :user_awards do |t|
      t.references :user, index: true, null: false
      t.references :award, index: true, null: false
      t.timestamps null: false
    end
  end
end
