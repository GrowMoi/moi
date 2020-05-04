class RemoveOldRoomId < ActiveRecord::Migration
  def change
    remove_column :user_chats, :room_id
  end
end
