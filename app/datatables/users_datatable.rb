class UsersDatatable
  delegate :params, :h, :link_to, :number_to_currency, :admin_user_path, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.count,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        link_to(user.name, admin_user_path(user)),
        user.role,
        user.created_at.strftime("%B %e, %Y"),
        user.name
      ]
    end
  end

  def users
    @users ||= fetch_products
  end

  def fetch_products
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per(per_page)
    if params[:sSearch].present?
      users = users.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
