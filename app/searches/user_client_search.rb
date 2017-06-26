class UserClientSearch < Searchlight::Search
  search_on User.where(:role => :cliente)
  searches :q

  def search_q
    search.where("unaccent(users.name) ILIKE :q OR unaccent(users.email) ILIKE :q", q: "%#{q}%")
  end
end
