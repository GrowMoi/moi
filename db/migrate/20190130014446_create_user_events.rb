class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.references :user, index: true, null: false
      t.references :event, index: true, null: false
      t.boolean :completed, default: false
      t.timestamps null: false
    end
  end
end
