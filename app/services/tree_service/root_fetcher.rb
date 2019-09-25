module TreeService
  class RootFetcher
    def self.root_neuron
      @@root_neuron ||= Neuron.find(156)
    end
  end
end
