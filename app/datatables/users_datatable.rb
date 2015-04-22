class UsersDatatable
  delegate :params, :t, :link_to, :image_tag, to: :@view

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
    users.map do |raw_user|
      user = UserDatatableDecorator.new(raw_user, self)
      [
        user.avatar_and_name,
        user.email,
        user.role,
        user.link_for(:show) + user.link_for(:edit)
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

  # @todo this will raise an exception if `columns`
  #   doesn't have the requested index.
  #   We can have a `rescue` block
  def sort_column
    columns = %w[name email role]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
