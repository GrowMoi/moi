class AddTypeToContentLearningFinalTest < ActiveRecord::Migration
  def change
    add_column :content_learning_final_tests, :kind, :string, default: 'achievement'
  end
end
