class CreateCheckContentValidations < ActiveRecord::Migration
  def change
    create_table :check_content_validations do |t|
      t.references :reviewer, index: true, null: false
      t.references :request_content_validation, null: false
      t.boolean :approved,
        null: false,
        default: false
      t.string :message
      t.timestamps null: false
    end
  end
end
