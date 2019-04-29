class AddJsonToUserEvents < ActiveRecord::Migration
  def change
    add_column :user_events, :contents, :json, array: true, default: []
    add_column :user_events, :contents_learning, :json, array: true, default: []
    add_column :user_events, :expired, :boolean, default: false
  end
end
