module Api
  class TreeNeuronSerializer < ActiveModel::Serializer
    root false

    ATTRIBUTES = TreeService::UserTreeFetcher::ATTRIBUTES + [
      :children
    ].freeze

    attributes *ATTRIBUTES

    def children
      @children
    end

    def children=(new_children)
      @children = new_children
    end
  end
end
