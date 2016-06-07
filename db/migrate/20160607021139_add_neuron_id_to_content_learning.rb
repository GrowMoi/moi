class AddNeuronIdToContentLearning < ActiveRecord::Migration
  def change
    add_reference :content_learnings,
                  :neuron,
                  null: false,
                  index: true,
                  foreign_key: true
  end
end
