class CreateUserTutorRecommendations < ActiveRecord::Migration
  def change
    create_table :user_tutor_recommendations do |t|
      t.references :user_tutor, index: true, null: false
      t.references :tutor_recommendation, index: true, null: false
      t.timestamps null: false
    end
  end
end
