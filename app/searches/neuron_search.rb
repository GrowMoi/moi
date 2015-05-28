class NeuronSearch < Searchlight::Search
  search_on Neuron.all
  searches :q

  def self.custom_search(options={})
    self.search_target = options.fetch :scope
    new(q: options.fetch(:q))
  end

  def search_q
    search.includes(:contents)
          .where("title ILIKE :q OR contents.description ILIKE :q", q: "%#{q}%")
          .references(:contents)
  end
end
