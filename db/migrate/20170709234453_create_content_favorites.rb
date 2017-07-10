class CreateContentFavorites < ActiveRecord::Migration
  def change
    create_table :content_favorites do |t|
      t.references :user, index: true, null: false
      t.references :content, index: true, null: false
      t.timestamps null: false
    end
  end
end
