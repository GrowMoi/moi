class CreateLevelQuizzes < ActiveRecord::Migration
  def change
    create_table :level_quizzes do |t|
      t.string :name, null:false
      t.string :description
      t.text :content_ids, array: true, default: []
      t.timestamps null: false
    end
  end
end
