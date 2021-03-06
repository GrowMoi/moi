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
  reportUserLink = '#report-user-link'

  $(listClientsId).selectable
    filter: '.row-client'
    create: (event, ui) ->
      userId = sessionStorage.getItem('userId')
      if userId
        user = $(this).find("#user_#{userId}")
        user.addClass('selectedfilter').addClass('ui-selected')
        if $(analisysUserLink).hasClass('disabled')
          $(analisysUserLink).removeClass('disabled')

        isStudent = (user.parent().attr('id') == 'list-students')
        if isStudent
          $(analisysUserLink).hide()
          $(reportUserLink).show()
          addUserIdToLink($(reportUserLink), userId)
        else
          $(analisysUserLink).show()
          $(reportUserLink).hide()
      else
        $(analisysUserLink).addClass('disabled')
        $(reportUserLink).hide()
      return

    selected: (event, ui) ->
      user = $(ui.selected)
      if $(analisysUserLink).hasClass('disabled') || isStudent
        $(analisysUserLink).removeClass('disabled')

      user.addClass('visible')
      user.addClass('selectedfilter').addClass('ui-selected')
      regexUser = /user_(\d*)/
      userId = regexUser.exec(ui.selected.id)[1]
      sessionStorage.setItem('userId', userId)
      customizeNavbarLink()

      isStudent = (user.parent().attr('id') == 'list-students')
      if isStudent
        $(analisysUserLink).hide()
        addUserIdToLink($(reportUserLink), userId)
        $(reportUserLink).show()
      else
        $(reportUserLink).hide()
        $(analisysUserLink).show()


      return

    unselected: (event, ui) ->
      $(analisysUserLink).show()
      $(analisysUserLink).addClass('disabled')
      $(reportUserLink).hide()
      $(ui.unselected).removeClass('selectedfilter')
      return

  loadUserLinks()
  return

addUserIdToLink = (element, userId) ->
  if userId
    baseUrl = '/tutor/report'
    href = element.attr('href')
    userHref = baseUrl + "/?user_id=#{userId}"
    element.attr('href', userHref)
  return

$(document).on "ready page:load", loadSelectableList
