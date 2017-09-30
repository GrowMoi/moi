class CreateContentLevelQuizzes < ActiveRecord::Migration
  def change
    create_table :content_level_quizzes do |t|
      t.references :content, index: true, null: false
      t.references :level_quiz, index: true, null: false
      t.timestamps null: false
    end
  end
end
