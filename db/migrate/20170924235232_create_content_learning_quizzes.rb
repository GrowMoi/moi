class CreateContentLearningQuizzes < ActiveRecord::Migration
  def change
    create_table :content_learning_quizzes do |t|
      t.references :player,
                   null: false,
                   index: true,
                   foreign_key: true
      t.json :questions,
             null: false
      t.json :answers

      t.timestamps null: false
    end
  end
end
