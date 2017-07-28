customizeNavbarLink = ->
  userId = sessionStorage.getItem('userId')
  if userId
    $navbarLinkClient = $('#navbar-link-client')
    $navbarLinkAnalysis = $('#navbar-link-analysis')
    clientHref = $navbarLinkClient.attr('href')
    analysisHref = $navbarLinkAnalysis.attr('href')
    regexUrl = /\/\w*\/\w*/
    clientHref = regexUrl.exec(clientHref)[0]
    analysisHref = regexUrl.exec(analysisHref)[0]
    $navbarLinkClient.attr('href', "#{clientHref}/#{userId}")
    $navbarLinkAnalysis.attr('href', "#{analysisHref}/#{userId}")

    $analisysUserLink = $('#analysis-user-link')
    if $analisysUserLink[0]
      analisysUserHref = $analisysUserLink.attr('href')
      analisysUserHref = regexUrl.exec(analisysUserHref)[0]
      $analisysUserLink.attr('href', "#{analisysUserHref}/?user_id=#{userId}")
  return

loadUserLinks = ->
  if sessionStorage.getItem('userId')
    customizeNavbarLink()
  return

loadSelectableList = ->
  listClientsId = '#list-select'
  analisysUserLink = '#analysis-user-link'

  $(listClientsId).selectable
    filter: '.row-client'

    create: (event, ui) ->
      userId = sessionStorage.getItem('userId')
      if userId
        $(this).find("#user_#{userId}").addClass('selectedfilter').addClass('ui-selected')
        if $(analisysUserLink).hasClass('disabled')
          $(analisysUserLink).removeClass('disabled')
      else
        $(analisysUserLink).addClass('disabled')
      return

    selected: (event, ui) ->
      if $(analisysUserLink).hasClass('disabled')
        $(analisysUserLink).removeClass('disabled')

      $(ui.selected).addClass('visible')
      $(ui.selected).addClass('selectedfilter').addClass('ui-selected')
      regexUser = /user_(\d*)/
      userId = regexUser.exec(ui.selected.id)[1]
      sessionStorage.setItem('userId', userId)
      customizeNavbarLink()
      return

    unselected: (event, ui) ->
      $(analisysUserLink).addClass('disabled')
      $(ui.unselected).removeClass('selectedfilter')
      return

$(document).on "ready page:load", loadSelectableList
$(document).on "ready page:load", loadUserLinks
