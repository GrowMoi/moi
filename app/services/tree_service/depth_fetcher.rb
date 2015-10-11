module TreeService
  class DepthFetcher
    attr_reader :depth, :scope

    def initialize(options)
      @depth = options.fetch :depth
      @scope = options.fetch(:scope) { nil }
    end

    def neurons
      levels = { 0 => [root_neuron] }
      (1..depth).each do |level|
        parents = levels.fetch(level - 1)
        levels[level] = children_for(parents)
      end
      levels.values.flatten
    end

    private

    def children_for(neurons)
      Neuron.where(
        parent_id: parent_ids_for(neurons)
      )
    end

    def parent_ids_for(neurons)
      @scope_ids ||= scope.pluck(:id) if scope.present?
      ids = neurons.map(&:id)
      if @scope_ids.present?
        @scope_ids & ids
      else
        ids
      end
    end

    def root_neuron
      TreeService::RootFetcher.root_neuron
    end
  end
end
