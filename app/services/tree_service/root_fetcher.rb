module TreeService
  class RootFetcher
    def self.root_neuron
      neuron_root_id = 50 #haedus
      @@root_neuron ||= Neuron.find(neuron_root_id)
    end
  end
end
