class NeuronSearch < Searchlight::Search
  search_on Neuron.all
  searches :q

  def search_q
    search.where("unaccent(neurons.title) ILIKE :q", q: "%#{q}%").where(['is_public', true])
  end
end
