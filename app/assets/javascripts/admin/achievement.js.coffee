enableInputQuantity = (category) ->
  $inputQuantity = $('.input-quantity-container')
  $checkboxContainer = $('.check-box-container')

  if (category == 'test')
    $inputQuantity.show()
    $checkboxContainer.hide()
  if (category == 'content')
    $inputQuantity.show()
    $checkboxContainer.show()
  if (category == 'time')
    $inputQuantity.hide()
    $checkboxContainer.hide()

  return

formatValue = (value) ->
  if ($.type(value) == 'string')
      return $.parseJSON(value)
  return value

enableInputNumber = (checked) ->
  $numberField = $('#number-field-quantity')
  if (checked)
    $numberField.addClass('disabled')
  else
    $numberField.removeClass('disabled')
  return

enableEvents = ->
  $learnAllContents = $('#check-box-learn-all-contents')
  $category = $('#select-category')
  categorySelected = $category.val()
  isChecked = formatValue($learnAllContents.val())

  if (isChecked)
    $learnAllContents.attr('checked', true)
    $learnAllContents.val('true')
  else
    $learnAllContents.attr('checked', false)
    $learnAllContents.val('false')

  enableInputQuantity(categorySelected)
  enableInputNumber(isChecked)

  $learnAllContents.change (e, data) ->
    checked = formatValue(this.checked)

    if (checked)
      this.value = "true"
    else
      this.value = "false"

    enableInputNumber(checked)

  $category.change (e, data) ->
    enableInputQuantity(data.selected)

  return

$(document).on 'ready page:load', enableEvents
