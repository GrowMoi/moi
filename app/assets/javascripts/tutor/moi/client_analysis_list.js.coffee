loadAnalysisSelectableList = ->
  listId = '#list-clients-analysis'
  linkId = '#analysis-link'

  $(listId).selectable
    create: (event, ui) ->
      $(linkId).addClass('disabled')
      return
    selected: (event, ui) ->
      if $(linkId).hasClass('disabled')
        $(linkId).removeClass('disabled')
      $(ui).addClass('visible')
      regex = /user_(\d*)/g
      regexUrl = /\/\w*\/\w*/g
      userId = regex.exec(ui.selected.id)[1]
      $analysisLink = $(linkId)
      href = $analysisLink.attr('href')
      href = regexUrl.exec(href)[0]
      $analysisLink.attr('href', "#{href}/#{userId}")
      return
    unselected: (event, ui) ->
      $(linkId).addClass('disabled')
      return
$(document).on "ready page:load", loadAnalysisSelectableList
