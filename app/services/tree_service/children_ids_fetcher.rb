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
      collection.map(&:id)
    end
  end
end
