class CreateContentQuestions < ActiveRecord::Migration
  def change
    create_table :content_questions do |t|
      t.string :question
      t.references :content,
                    null: false,
                    index: true
      t.timestamps null: false
    end
  end
end
