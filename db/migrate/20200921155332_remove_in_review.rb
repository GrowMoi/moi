class RemoveInReview < ActiveRecord::Migration
  def change
    remove_columns :request_content_validations, :in_review
  end
end
