loadSelectableList = ->
  listId = '#list-clients'
  clientLinkId = '#client-link'
  analisysLink = '#analysis-user-link'

  $(listId).selectable
    create: (event, ui) ->
      $(analisysLink).addClass('disabled')

    selected: (event, ui) ->
      if $(analisysLink).hasClass('disabled')
        $(analisysLink).removeClass('disabled')

      if $(ui.selected).hasClass('selectedfilter')
        $(ui.selected).removeClass('selectedfilter').removeClass('ui-selected')
      else
        $(ui.selected).addClass('visible')
        $(ui.selected).addClass('selectedfilter').addClass('ui-selected')
        regex = /user_(\d*)/g
        regexUrl = /\/\w*\/\w*/g
        regexUrl2 = /\/\w*\/\w*/g
        userId = regex.exec(ui.selected.id)[1]
        $clientLink = $(clientLinkId)
        $analysisLink = $(analisysLink)
        clientHref = $clientLink.attr('href')
        clientHref = regexUrl.exec(clientHref)[0]
        analisysHref = $analysisLink.attr('href')
        analisysHref = regexUrl2.exec(analisysHref)[0]
        $clientLink.attr('href', "#{clientHref}/#{userId}")
        $analysisLink.attr('href', "#{analisysHref}/#{userId}")

    unselected: (event, ui) ->
      $(analisysLink).addClass('disabled')
      $(ui.unselected).removeClass('selectedfilter')

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
