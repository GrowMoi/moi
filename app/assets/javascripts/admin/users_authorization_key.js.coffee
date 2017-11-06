wrapper = ".authorization-keys-in-form"
targetInput = "#user_authorization_key"

applyValue = (value) ->
  $(targetInput).val value

unselectOptions = ->
  $("#{wrapper} img").removeClass "active"

imgSelected = (e) ->
  unselectOptions()
  $target = $(e.target)
  $target.addClass "active"
  applyValue($target.data("key"))

$(document).on "click", "#{wrapper} img", imgSelected
