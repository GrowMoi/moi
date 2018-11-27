class ContentImportingType < ActiveRecord::Migration
  def change
    add_column :content_importings, :kind, :string, default: 'normal'
  end
end
