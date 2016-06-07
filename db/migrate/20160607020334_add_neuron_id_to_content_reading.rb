class AddNeuronIdToContentReading < ActiveRecord::Migration
  def change
    add_reference :content_readings,
                  :neuron,
                  null: false,
                  index: true,
                  foreign_key: true
  end
end
