class NeuronSerializer < ActiveModel::Serializer
  attributes :id,
             :parent_id,
             :title
end
