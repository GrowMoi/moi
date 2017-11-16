class CreateClientTutorRecommendations < ActiveRecord::Migration
  def change
    create_table :client_tutor_recommendations do |t|
      t.references :client, index: true, null: false
      t.references :tutor_recommendation, index: true, null: false
      t.string :status, null: false
      t.timestamps null: false
    end
    add_index :client_tutor_recommendations, :status
    add_foreign_key :client_tutor_recommendations, :users, column: :client_id
  end
end
