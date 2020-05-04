class CreateUserChats < ActiveRecord::Migration
  def change
    create_table :user_chats do |t|
      t.references :sender, index: true, null: false
      t.references :receiver, index: true, null: false
      t.text :message, null: false

      t.timestamps null: false
    end
    add_foreign_key :user_chats, :users, column: :sender_id
    add_foreign_key :user_chats, :users, column: :receiver_id
  end
end
