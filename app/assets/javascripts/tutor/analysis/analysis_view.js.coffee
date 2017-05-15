loadAnalysisSelectableList = ->
  listId = '#list-clients-analysis'
  analisysLink = '#analysis-link'

  $(listId).selectable
    create: (event, ui) ->
      $(analisysLink).addClass('disabled')
      return

    selected: (event, ui) ->
      if $(analisysLink).hasClass('disabled')
        $(analisysLink).removeClass('disabled')

      if $(ui.selected).hasClass('selectedfilter')
        $(ui.selected).removeClass('selectedfilter').removeClass('ui-selected')
      else
        $(ui.selected).addClass('visible')
        regex = /user_(\d*)/g
        regexUrl = /\/\w*\/\w*/g
        userId = regex.exec(ui.selected.id)[1]
        $analysisLink = $(analisysLink)
        analisysHref = $analysisLink.attr('href')
        analisysHref = regexUrl.exec(analisysHref)[0]
        $analysisLink.attr('href', "#{analisysHref}/#{userId}")
      return

    unselected: (event, ui) ->
      $(analisysLink).addClass('disabled')
      $(ui.unselected).removeClass('selectedfilter')
      return

$(document).on "ready page:load", loadAnalysisSelectableList
