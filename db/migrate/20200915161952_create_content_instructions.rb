class CreateContentInstructions < ActiveRecord::Migration
  def change
    create_table :content_instructions do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.boolean :required_media
      t.references :content, index: true
      t.timestamps null: false
    end
  end
end
