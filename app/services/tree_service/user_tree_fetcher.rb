module TreeService
  class UserTreeFetcher
    extend Forwardable

    SERIALIZER = "Api::TreeNeuronSerializer"
    ATTRIBUTES = %w(
      id
      title
      parent_id
    ).map(&:to_sym).freeze

    attr_reader :scope,
                :children_fetcher,
                :depth,
                :root,
                :depth_calculator,
                :user

    def initialize(user, desired_neuron_path)
      @user = user
      @scope = PublicScopeFetcher.new(user).neurons
      @children_fetcher = ChildrenIdsFetcher.new(scope)
      @depth = 0
      @depth_calculator = NeuronDepthCalculator.new
      @desired_neuron_path = desired_neuron_path
      @root = serialize(RootFetcher.root_neuron)
      #update level user
      @user.level = @depth
      @user.save
    end

    private

    def update_tree_depth(neuron)
      neuron_depth = depth_calculator.for(neuron)
      if neuron_depth > depth
        @depth = neuron_depth
      end
    end

    def children_for(neuron)
      children_fetcher.children_for(neuron)
                      .select(*ATTRIBUTES)
                      .map do |child|
        serialize(child)
      end
    end

    def serialize(neuron)
      serializer_klass.new(
        neuron,
        scope: user,
        context: {
          desired_neuron_path: @desired_neuron_path,
          contents_learning_ids: contents_learning_ids
        }
      ).tap do |serializer|
        update_tree_depth(serializer.object)
        serializer.children = children_for(
          serializer.object
        )
      end
    end

    def serializer_klass
      SERIALIZER.constantize
    end

    def contents_learning_ids
      ContentLearning.where(user: user).map(&:content_id)
    end
  end
end
