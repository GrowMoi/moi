class CreateTranslatedAttributes < ActiveRecord::Migration
  def change
    create_table :translated_attributes do |t|
      t.integer :translatable_id, null: false
      t.string :translatable_type, null: false
      t.string :name, null: false
      t.text :content
      t.string :language, null: false

      t.timestamps null: false
    end

    add_index :translated_attributes,
              [:translatable_id, :translatable_type],
              name: "index_translated_attributes_resource"
  end
end
