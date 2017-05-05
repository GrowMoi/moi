loadSelectableList = ->
  listId = '#list-clients'
  clientLinkId = '#client-link'

  $(listId).selectable selected: (event, ui) ->
    $(ui).addClass('visible')
    regex = /user_(\d*)/g
    regexUrl = /\/\w*\/\w*/g
    userId = regex.exec(ui.selected.id)[1]
    $clientLink = $(clientLinkId)
    href = $clientLink.attr('href')
    href = regexUrl.exec(href)[0]
    $clientLink.attr('href', "#{href}/#{userId}")

loadActivityUserLink = ->
  activityLinkId = '#link-user-client-activity'
  currentPath = window.location.pathname
  regexUrl = /\/\w*\/\w*\/(\d+)/g
  res = regexUrl.exec(currentPath)

  if res
    userId = res[1]
    $activityLink = $(activityLinkId)
    activityHref = $activityLink.attr('href')
    $activityLink.attr('href', "#{activityHref}/#{userId}")

$(document).on "ready page:load", loadSelectableList
$(document).on "ready page:load", loadActivityUserLink
