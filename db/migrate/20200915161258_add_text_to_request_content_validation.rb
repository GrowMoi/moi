class AddTextToRequestContentValidation < ActiveRecord::Migration
  def change
    add_column :request_content_validations, :text, :string
  end
end
