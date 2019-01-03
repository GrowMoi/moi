class AddStartEndTimeExpiration < ActiveRecord::Migration
  def change
    add_column :user_tutors, :start_date_request, :datetime
    add_column :user_tutors, :end_date_request, :datetime
  end
end
