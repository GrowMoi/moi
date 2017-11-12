class CreateTutorRecommendations < ActiveRecord::Migration
  def change
    create_table :tutor_recommendations do |t|
      t.references :user, index: true, null: false
      t.references :tutor_achievement, index: true
      t.timestamps null: false
    end
  end
end
