class AddLanguageToContentLink < ActiveRecord::Migration
  def change
    add_column :content_links, :language, :string, default: "es"
    add_index :content_links, :language
  end
end
