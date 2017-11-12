class CreateClientApprovedRecommendations < ActiveRecord::Migration
  def change
    create_table :client_approved_recommendations do |t|
      t.references :user, index: {:name => "user_id"}, null: false
      t.references :tutor_recommendation, index: {:name => "tutor_recommendation_id"}, null: false
      t.timestamps null: false
    end
  end
end
