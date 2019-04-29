class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :description
      t.string :image
      t.text :content_ids, array: true, default: []
      t.text :publish_days, array: true, default: []
      t.integer :duration, null: false #hours
      t.string :kind
      t.integer :user_level, default: 1
      t.timestamps null: false
    end
  end
end
