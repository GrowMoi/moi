class UsersDatatable
  delegate :params, :t, :link_to, :image_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users_scope.count,
      aaData: data
    }
  end

private

  def data
    users.map do |raw_user|
      user = UserDatatableDecorator.new(raw_user, self)
      [
        checkbox_for(user),
        user.avatar_and_name,
        user.record.name,
        user.email,
        user.role,
        action_links_for(user)
      ]
    end
  end

  def checkbox_for(user)
    "<input type='checkbox' class='select-single-record' name='select-single-record[]' value='#{user.id}'>"
  end

  def action_links_for(user)
    [
      user.link_for(:show),
      "<br>",
      user.link_for(:edit),
      "<br>",
      user.link_for_destroy(:destroy)
    ].join(" ").html_safe
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users_scope.page(page).per(per_page)
  end

  def users_scope
    @users_scope ||= begin
      scope = User.order("#{sort_column} #{sort_direction}")
      if params[:sSearch].present?
        scope = scope.where(
          "name ILIKE :search OR email ILIKE :search",
          search: "%#{params[:sSearch]}%"
        )
      end
      scope
    end
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
