class AddKindToUserChat < ActiveRecord::Migration
  def change
    add_column :user_chats, :kind, :string, null: false, default: "user"
  end
end
