class AddInReviewToRequestContentValidation < ActiveRecord::Migration
  def change
    add_column :request_content_validations, :in_review, :boolean
  end
end
