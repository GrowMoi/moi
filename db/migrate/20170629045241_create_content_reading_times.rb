class CreateContentReadingTimes < ActiveRecord::Migration
  def change
    create_table :content_reading_times do |t|
      t.references :content, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.float :time, null: false

      t.datetime :created_at, null: false
    end
  end
end
