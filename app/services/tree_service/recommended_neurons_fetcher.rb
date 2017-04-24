module TreeService
  class RecommendedNeuronsFetcher

    attr_reader :user, :neurons, :neurons_tree, :recommended

    def initialize(options)
      @neurons = []
      @user = options.fetch(:user)
      @neurons_tree = UserTreeFetcher.new(user).children_fetcher
    end

    def recommended
      fetch_pool!
    end

    private

    def fetch_pool!
      neurons_tree.scope.each do |neuron|
        unless user.already_learnt_any?(neuron.contents)
          neurons << neuron
        end
      end
      neurons
    end

  end
end
