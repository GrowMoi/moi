class UserClientSearch < Searchlight::Search
  search_on User.where(:role => :cliente)
  searches :q

  def search_q
    unless @q.blank?
      q = ActiveSupport::Inflector.transliterate(@q).to_s
    end
    search.where("unaccent(users.username) ILIKE :q OR unaccent(users.name) ILIKE :q OR unaccent(users.email) ILIKE :q", q: "%#{q}%")
  end
end
