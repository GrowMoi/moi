namespace :neurons do
  task counter_cache_pending_contents: :environment do
    Neuron.find_each do |neuron|
      puts "caching contents for neuron #{neuron.id} #{neuron}"
      neuron.counter_cache_pending_contents!
      neuron.save validate: false
    end
  end
end
