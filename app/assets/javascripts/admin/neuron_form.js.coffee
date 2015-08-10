selector = "form.neuron-form"
formHasChanged = false

$(document).on "page:load", ->
  formHasChanged = false

$(document).on "change", "#{selector} input", ->
  formHasChanged = true

$(document).on "page:before-change", ->
  confirm(
    "La información no ha sido guardada. ¿Estás seguro de continuar?"
  ) if formHasChanged
