module TreeService
  class NeuronsFetcher
    # TODO find a way to get main neurons
    ROOT_NEURON_COLOR = 'yellow'
    BRANCHES = {
      language: {
        name: 'Lenguaje',
        color: 'yellow',
        ids: []
      },
      art: {
        name: 'Artes',
        color: 'red',
        ids: []
      },
      learn: {
        name: 'Aprender',
        color: 'blue',
        ids: []
      },
      nature: {
        name: 'Naturaleza',
        color: 'green',
        ids: []
      }
    }

    def initialize(neuron)
      @neuron = neuron
    end

    def neurons_ids_by_branch
      BRANCHES.each do |key, value|
        branch = value[:name].downcase
        neuron_branch = Neuron.where('lower(title) = ?', branch).first
        branch_ids = TreeService::RecursiveChildrenIdsFetcher.new(
          neuron_branch
        ).children_ids
        branch_ids = branch_ids << neuron_branch.id
        value[:ids] = branch_ids
      end
      BRANCHES
    end


    def neuron_color(ids_branches)
      color = nil
      branches_neurons_ids = ids_branches || neurons_ids_by_branch
      root_neuron = TreeService::RootFetcher.root_neuron
      if @neuron.id === root_neuron.id
        return ROOT_NEURON_COLOR
      end
      unless (branches_neurons_ids[:language][:ids] & [@neuron.id]).empty?
        return branches_neurons_ids[:language][:color]
      end
      unless (branches_neurons_ids[:art][:ids] & [@neuron.id]).empty?
        return branches_neurons_ids[:art][:color]
      end
      unless (branches_neurons_ids[:learn][:ids] & [@neuron.id]).empty?
        return branches_neurons_ids[:learn][:color]
      end
      unless (branches_neurons_ids[:nature][:ids] & [@neuron.id]).empty?
        return branches_neurons_ids[:nature][:color]
      end
    end
  end
end
