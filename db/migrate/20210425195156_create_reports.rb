class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :kind
      t.string :status

      t.timestamps null: false
    end
  end
end
