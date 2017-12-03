class Neuron < ActiveRecord::Base
  module Branches

    def ids_yellow_branch
      neurons_by_branches[0]
    end

    def ids_blue_branch
      neurons_by_branches[1]
    end

    def ids_red_branch
      neurons_by_branches[2]
    end

    def ids_green_branch
      neurons_by_branches[3]
    end

    private

    def neurons_by_branches
      all_neurons = Neuron.where(is_public: true, active: true)
      parent = Neuron.where(parent_id: nil).first
      branches = Neuron.where(parent_id: parent.id)
      result = []
      branches.each do |neuron_branch|
        result << children_neurons_no_query([], neuron_branch, all_neurons).flatten.map(&:id)
      end
      result
    end

    def children_neurons_no_query(children_array = [], neuron, all_neurons)
      children = get_children_tree(neuron, all_neurons)
      children_array << children
      children.each do |child|
        children_neurons_no_query(children_array, child, all_neurons)
      end
      children_array
    end

    def get_children_tree(neuron_branch, all_neurons)
      children = all_neurons.select do |neuron|
        neuron.parent_id != nil ? neuron.parent_id == neuron_branch.id : false
      end
      # puts "#{children.map(&:id)}"
      return children
    end

  end
end
