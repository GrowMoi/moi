class NeuronSerializer < ActiveModel::Serializer
  attributes :name
  has_many :children

  def name
    object.title
  end

  def children
    Neuron.where(parent_id: object.id)
  end

end
