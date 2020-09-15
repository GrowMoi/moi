class RemoveFieldsFromContent < ActiveRecord::Migration
  def change
    remove_columns :contents, :instructions, :title_instruction
  end
end