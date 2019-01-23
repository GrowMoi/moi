class AddLanguageToContentVideo < ActiveRecord::Migration
  def change
    add_column :content_videos, :language, :string, default: "es"
    add_index :content_videos, :language
  end
end
