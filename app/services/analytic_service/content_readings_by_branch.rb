module AnalyticService
  class ContentReadingsByBranch
    def initialize(user)
      @user = user
   end

    def results
      root_children.inject({}) do |memo, child|
        memo[child] = reading_count_for(child)
        memo
      end
    end

    private

    def root_children
      root = TreeService::RootFetcher.root_neuron
      Neuron.where(parent_id: root.id)
    end

    def reading_count_for(neuron)
      children_ids = TreeService::RecursiveChildrenIdsFetcher.new(
        neuron
      ).children_ids
      children_ids.push(neuron.id)
      ContentReading.where(neuron_id: children_ids).count
    end
  end
end
