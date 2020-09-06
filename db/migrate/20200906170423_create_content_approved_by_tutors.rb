class CreateContentApprovedByTutors < ActiveRecord::Migration
  def change
    create_table :content_approved_by_tutors do |t|
      t.references :tutor, index: true, null: false
      t.references :user, index: true, null: false
      t.references :content,
          null: false,
          index: true
      t.boolean :approved,
        null: false,
        default: true
      t.string :message
      t.string :media, null: false
      t.timestamps null: false
    end
  end
end
