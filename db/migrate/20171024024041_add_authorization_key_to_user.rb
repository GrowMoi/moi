class AddAuthorizationKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :authorization_key, :string
    add_index :users, :authorization_key
  end
end
