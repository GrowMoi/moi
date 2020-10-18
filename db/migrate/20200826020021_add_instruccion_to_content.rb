class AddInstruccionToContent < ActiveRecord::Migration
  def change
    add_column :contents, :instructions, :string
  end
end
