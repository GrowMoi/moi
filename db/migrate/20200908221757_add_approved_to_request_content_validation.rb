class AddApprovedToRequestContentValidation < ActiveRecord::Migration
  def change
    add_column :request_content_validations, :approved, :boolean
  end
end
