module TreeService
  class PublicScopeFetcher
    extend Forwardable

    attr_reader :user
    def_delegators :@children_fetcher, :children_for

    def initialize(user)
      @user = user
      @children_fetcher = ChildrenIdsFetcher.new(
        public_scope
      )
    end

    def neurons
      @neurons ||= scoped
    end

    private

    def scoped
      public_scope.where(
        id: pool_ids + children_for(pool_ids)
      )
    end

    def pool_ids
      [
        root_neuron.id
      ] + learnt_neurons.ids
    end

    def learnt_neurons
      @learnt_neurons ||= LearntNeuronsFetcher.new(user)
    end

    def public_scope
      Neuron.published
    end

    def root_neuron
      RootFetcher.root_neuron
    end
  end
end