class CreateContentTutorRecommendations < ActiveRecord::Migration
  def change
    create_table :content_tutor_recommendations do |t|
      t.references :content, index: true, null: false
      t.references :tutor_recommendation, index: true, null: false
      t.timestamps null: false
    end
  end
end
