class CreateContentVideos < ActiveRecord::Migration
  def change
    create_table :content_videos do |t|
      t.references :content,
                   null: false,
                   index: true,
                   foreign_key: true
      t.string :url, null: false
      t.timestamps null: false
    end
  end
end
