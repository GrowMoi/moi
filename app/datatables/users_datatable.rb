class UsersDatatable
  delegate :params, :t, :link_to, :edit_admin_user_path, to: :@view

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
        user.name,
        user.email,
        user.role,
        link_to(t("actions.edit"), edit_admin_user_path(user))
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per(per_page)
    if params[:sSearch].present?
      users = users.where("name like :search or email like :search or role like :search", search: "%#{params[:sSearch]}%")
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
    columns = %w[name email role]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
