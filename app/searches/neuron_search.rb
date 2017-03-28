class NeuronSearch < Searchlight::Search
  search_on Neuron.all
  searches :q

  def search_q
    search.includes(:contents)
          .where("unaccent(neurons.title) ILIKE :q OR unaccent(contents.title) ILIKE :q OR unaccent(contents.description) ILIKE :q", q: "%#{q}%")
          .references(:contents)
  end
end
