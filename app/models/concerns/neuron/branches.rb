class Neuron < ActiveRecord::Base
  module Branches

    def contents_learnt_by_branches
      branches = neurons_by_branches_hash
      all_contents = Content.approved.all.map(&:id)
      user_contents = User.last.content_learnings.map(&:content_id)
      result = []
      branches.map do |branch|
        learnt_contents = Hash.new
        learnt_contents['branch'] = branch['title']
        contents_by_branch = Content.approved.where(neuron_id: branch['neuron_ids']).map(&:id)
        learnt_contents['learnt_content_ids'] = contents_by_branch & user_contents
        result << learnt_contents
      end
      result
    end

    def neurons_by_branches_hash
      all_neurons = Neuron.where(is_public: true, active: true)
      parent = Neuron.where(parent_id: nil).first
      branches = Neuron.where(parent_id: parent.id)
      result = []
      branches.each do |neuron_branch|
        branch = Hash.new
        branch['title']= neuron_branch.title
        #add id to branch
        ids = get_children_neurons([], neuron_branch, all_neurons).flatten.map(&:id) << neuron_branch.id
        branch['neuron_ids'] = ids
        result << branch
      end
      result
    end

    private

    def get_children_neurons(children_array = [], neuron, all_neurons)
      children = get_children_tree(neuron, all_neurons)
      children_array << children
      children.each do |child|
        get_children_neurons(children_array, child, all_neurons)
      end
      children_array
    end

    def get_children_tree(neuron_branch, all_neurons)
      children = all_neurons.select do |neuron|
        neuron.parent_id != nil ? neuron.parent_id == neuron_branch.id : false
      end
      return children
    end

  end
end
