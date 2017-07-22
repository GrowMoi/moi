class CreateNotificationLinks < ActiveRecord::Migration

  def up
    create_table :notification_links do |t|
      t.references :notification,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :link, null: false
      t.timestamps null: false
    end
  end

  def down
    drop_table :notification_links
  end
end
