class AddPendingContentsCountToNeuron < ActiveRecord::Migration
  def change
    add_column :neurons, :pending_contents_count, :integer, default: 0
    add_index :neurons, :pending_contents_count
  end
end
