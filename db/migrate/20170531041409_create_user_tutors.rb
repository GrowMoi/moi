class CreateUserTutors < ActiveRecord::Migration
  def change
    create_table :user_tutors do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :tutor, index: true, null: false
      t.string :status

      t.timestamps null: false
    end
    add_index :user_tutors, :status
    add_foreign_key :user_tutors, :users, column: :tutor_id
  end
end
