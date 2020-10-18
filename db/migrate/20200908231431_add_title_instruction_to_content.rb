class AddTitleInstructionToContent < ActiveRecord::Migration
  def change
    add_column :contents, :title_instruction, :string
  end
end
