module TreeService
  class RecursiveChildrenIdsFetcher
    def initialize(neuron)
      @neuron = neuron
      @ids = []
    end

    def children_ids
      while ids_for_level = fetch_ids_for_level
        @ids += ids_for_level
      end
      @ids
    end

    private

    def fetch_ids_for_level
      @level_ids ||= @neuron.id
      scope = Neuron.where(parent_id: @level_ids)
      @level_ids = scope.pluck(:id)
      if scope.count > 0
        return @level_ids
      end
      return nil
    end
  end
end
