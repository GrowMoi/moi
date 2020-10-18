class RemoveNullColumn < ActiveRecord::Migration
  def change
    change_column_null :request_content_validations, :media, true
  end
end
