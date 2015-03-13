class AddFieldsToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :content_id, :integer
    add_column :versions, :level, :integer
    add_column :versions, :kind, :integer
    add_column :versions, :description, :text
    add_column :versions, :neuron_id, :integer
  end
end
