module TreeService
  class RecursiveParentsIdsFetcher
    def initialize(neuronId)
      @lastNeuronId = neuronId
      @ids = [neuronId]
    end

    def parents_ids
      lastNeuron = Neuron.where(id: @lastNeuronId).first
      while lastNeuron.parent_id
        lastNeuron = Neuron.where(id: lastNeuron.parent_id).first
        @ids.push(lastNeuron.id)
      end
      @ids
    end
  end
end
