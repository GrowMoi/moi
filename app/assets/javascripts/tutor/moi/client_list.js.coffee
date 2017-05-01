loadSelectableList = ->
  $('#list-clients').selectable selected: (event, ui) ->
    $(ui).addClass('visible')
    regex = /user_(\d*)/g
    regexUrl = /\/\w*\/\w*/g
    userId = regex.exec(ui.selected.id)[1]
    $clientLink = $('#client-link')
    href = $clientLink.attr('href')
    href = regexUrl.exec(href)[0]
    $clientLink.attr('href', "#{href}/#{userId}")
    return

$(document).on "ready page:load", loadSelectableList
