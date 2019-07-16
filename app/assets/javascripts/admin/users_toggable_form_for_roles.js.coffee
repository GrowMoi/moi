selector = "#user_role"

toggleContentsFor = (role) ->
  if role == "cliente"
    $(".content-for-admins").addClass "hidden"
    # $(".content-for-clients").removeClass "hidden"
  else # if role == "admin"
    $(".content-for-admins").removeClass "hidden"
    # $(".content-for-clients").addClass "hidden"

valueChanged = (e) ->
  newRole = e.target.value
  toggleContentsFor(newRole)

$(document).on "change", selector, valueChanged
