class AddReferenceLevelQuiz < ActiveRecord::Migration
  def up
    remove_column :quizzes, :level
    add_reference :quizzes,
                  :level_quiz,
                  null: false,
                  index: true,
                  foreign_key: true
  end

  def down
    add_column :quizzes, :level, :string
    remove_reference :quizzes, :level_quiz
  end
end
