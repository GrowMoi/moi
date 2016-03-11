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
      scoped
    end

    private

    def scoped
      public_scope.where(
        id: pool.map(&:id)
      )
    end

    def pool
      [
        root_neuron
      ] + children_for(root_neuron)
    end

    def public_scope
      Neuron.published
    end

    def root_neuron
      RootFetcher.root_neuron
    end
  end
end
