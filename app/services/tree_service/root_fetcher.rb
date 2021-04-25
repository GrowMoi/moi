module TreeService
  class RootFetcher
    def self.root_neuron
      @@root_neuron ||= Neuron.where(
        parent_id: nil,
        is_public: true,
        deleted: false,
        active: true
      ).last
    end
  end
end
