module TreeService
  class RootFetcher
    def self.root_neuron
      @@root_neuron ||= Neuron.find(12)
    end
  end
end
