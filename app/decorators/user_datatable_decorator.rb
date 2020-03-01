class UserDatatableDecorator < UserDecorator
  def avatar(opts = {})
    super(opts.merge(class: "margin-right #{opts[:class]}"))
  end

  def link_for(action)
    link_to(
      t("actions.#{action}"),
      path_for(action),
      class: "btn btn-xs btn-link"
    )
  end

  def link_for_destroy(action)
    link_to(
      t("actions.#{action}"),
      path_for(action),
      method: :delete,
      class: "btn btn-xs btn-link",
      data: { confirm: 'Estas seguro?' }
    )
  end

  def avatar_and_name
    link_to avatar + username, path_for(:show)
  end

  private

  def path_for(action)
    { controller: "users",
      action: action,
      id: id }
  end
end
