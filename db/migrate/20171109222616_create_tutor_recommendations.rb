class CreateTutorRecommendations < ActiveRecord::Migration
  def change
    create_table :tutor_recommendations do |t|
      t.references :tutor, index: true, null: false
      t.references :tutor_achievement, index: true
      t.timestamps null: false
    end
    add_foreign_key :tutor_recommendations, :users, column: :tutor_id
  end
end
