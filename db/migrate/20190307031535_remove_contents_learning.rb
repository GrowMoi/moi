class RemoveContentsLearning < ActiveRecord::Migration
  def up
    remove_column :user_events, :contents_learning
    remove_column :events, :publish_days
  end

  def down
    add_column :user_events, :contents_learning, :json, array: true, default: []
    add_column :events, :publish_days, :json, array: true, default: []
  end
end
