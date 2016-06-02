module TreeService
  class UserTreeFetcher
    extend Forwardable

    SERIALIZER = "Api::TreeNeuronSerializer"

    attr_reader :scope, :children_fetcher

    def initialize(user)
      @scope = PublicScopeFetcher.new(
        user
      ).neurons
      @children_fetcher = ChildrenIdsFetcher.new(
        scope
      )
    end

    def root
      serialize(
        RootFetcher.root_neuron
      )
    end

    private

    def children_for(neuron)
      children_fetcher.children_for(neuron).map do |child|
        serialize(child)
      end
    end

    def serialize(neuron)
      serializer_klass.new(neuron).tap do |serializer|
        serializer.children = children_for(
          serializer.object
        )
      end
    end

    def serializer_klass
      SERIALIZER.constantize
    end
  end
end
