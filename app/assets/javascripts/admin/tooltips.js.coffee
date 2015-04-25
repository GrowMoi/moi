applyTooltips = ->
  $(".bs-tooltip").tooltip()

$(document).on "ready page:load nested:fieldAdded",
               applyTooltips
