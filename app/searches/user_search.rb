class UserSearch < Searchlight::Search
  search_on User.all
  searches :q, :id

  def search_q
    unless @q.blank?
      q = ActiveSupport::Inflector.transliterate(@q).to_s
    end
    search.where("unaccent(users.username) ILIKE :q OR unaccent(users.name) ILIKE :q OR unaccent(users.email) ILIKE :q", q: "%#{q}%")
          .where.not("users.id = :id", id: id)
  end
end
