class AddCustomIndexChats < ActiveRecord::Migration
  def change
    add_column :user_chats, :room_id, :string
  end
end
