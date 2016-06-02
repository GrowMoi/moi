module Api
  class TreeNeuronSerializer < ActiveModel::Serializer
    root false

    attributes :id,
               :title,
               :children

    def children
      @children
    end

    def children=(new_children)
      @children = new_children
    end
  end
end
