class ContentSearch < Searchlight::Search
  search_on Content.all
  searches :q

  def search_q
    search.includes(:neuron)
          .where("unaccent(neurons.title) ILIKE :q OR unaccent(contents.title) ILIKE :q OR unaccent(contents.description) ILIKE :q", q: "%#{q}%")
          .where(['approved', true])
          .references(:neuron)
  end
end
