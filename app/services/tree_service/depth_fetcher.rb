module TreeService
  class DepthFetcher
    attr_reader :depth

    def initialize(options)
      @depth = options.fetch :depth
    end

    def neurons
      levels = {0 => [root_neuron]}
      (1..depth).each do |level|
        parents = levels.fetch(level-1)
        levels[level] = children_for(parents)
      end
      levels.values.flatten
    end

    private

    def children_for(neurons)
      Neuron.where(parent_id: neurons.map(&:id))
    end

    def root_neuron
      TreeService::RootFetcher.root_neuron
    end
  end
end
