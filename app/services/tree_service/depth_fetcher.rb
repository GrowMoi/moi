module TreeService
  class DepthFetcher
    extend Forwardable

    attr_reader :depth
    def_delegators :@children_fetcher, :children_for

    def initialize(options)
      @depth = options.fetch :depth
      @children_fetcher = ChildrenIdsFetcher.new(
        options.fetch(:scope)
      )
    end

    def neurons
      levels = { 0 => [root_neuron] }
      (1..depth).each do |level|
        parents = levels.fetch(level-1)
        levels[level] = children_for(parents)
      end
      levels.values.flatten
    end

    private

    def root_neuron
      TreeService::RootFetcher.root_neuron
    end
  end
end
