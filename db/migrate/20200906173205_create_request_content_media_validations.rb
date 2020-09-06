class CreateRequestContentMediaValidations < ActiveRecord::Migration
  def change
    create_table :request_content_media_validations do |t|
      t.references :user, index: true, null: false
      t.references :content,
      null: false,
      index: true
      t.string :media, null: false
      t.timestamps null: false
    end
  end
end
