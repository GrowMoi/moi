class AddReferenceRoomChat < ActiveRecord::Migration
  def change
    add_reference :user_chats,
                  :room_chat,
                  index: true,
                  foreign_key: true
  end
end
