enableInputQuantity = (category) ->
  $inputQuantity = $('.input-quantity-container')

  if (category == 'test')
    $inputQuantity.show()
  if (category == 'content')
    $inputQuantity.show()
  if (category == 'content_all')
    $inputQuantity.hide()
  if (category == 'time')
    $inputQuantity.hide()

  return

enableEvents = ->
  $category = $('#select-category')
  categorySelected = $category.val()

  enableInputQuantity(categorySelected)

  $category.change (e, data) ->
    enableInputQuantity(data.selected)

  return

$(document).on 'ready page:load', enableEvents
