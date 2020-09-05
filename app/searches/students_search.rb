class StudentsSearch < Searchlight::Search
  search_on User.all
  searches :q, :ids

  def search_ids
    unless @q.blank?
      q = ActiveSupport::Inflector.transliterate(@q).to_s
    end
    search.where(id: options[:ids])
          .where("unaccent(users.username) ILIKE :q OR unaccent(users.name) ILIKE :q OR unaccent(users.email) ILIKE :q", q: "%#{q}%")
  end

end
