class CreateContentLearningEvents < ActiveRecord::Migration
  def change
    create_table :content_learning_events do |t|
      t.references :user_event,
                   null: false,
                   index: true,
                   foreign_key: true
      t.references :content,
                  null: false,
                  index: true
      t.timestamps null: false
    end
  end
end
