class AddVideoToNeuron < ActiveRecord::Migration
  def change
    add_column :neurons, :video, :string
  end
end
