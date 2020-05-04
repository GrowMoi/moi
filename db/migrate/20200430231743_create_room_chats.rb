class CreateRoomChats < ActiveRecord::Migration
  def change
    create_table :room_chats do |t|
      t.references :sender, index: true, null: false
      t.references :receiver, index: true, null: false
      t.boolean :sender_leave, default: false
      t.boolean :receiver_leave, default: false
      t.timestamps null: false
    end
  end
end
