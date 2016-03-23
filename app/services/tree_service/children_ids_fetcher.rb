module TreeService
  class ChildrenIdsFetcher
    attr_reader :scope

    def initialize(scope)
      @scope = scope
    end

    def children_for(collection)
      scope.where(
        parent_id: ids_for(
          Array(collection)
        )
      ).select(:id)
    end

    private

    def ids_for(collection)
      if collection.first.is_a?(Neuron)
        collection.map(&:id)
      else
        collection
      end
    end
  end
end