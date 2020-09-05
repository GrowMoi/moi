class ContentSearch < Searchlight::Search
  search_on Neuron.approved_public_contents
  searches :q

  def search_q
    unless @q.blank?
      q = ActiveSupport::Inflector.transliterate(@q).to_s
    end
    search.where("unaccent(contents.title) ILIKE :q OR unaccent(contents.description) ILIKE :q", q: "%#{q}%")
          .where(['approved', true])
  end
end
