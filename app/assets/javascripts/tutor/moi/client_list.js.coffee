loadSelectableList = ->
  $('#list-clients').selectable selected: (event, ui) ->
    $(ui).addClass('visible')
    return

$(document).on "ready page:load", loadSelectableList
