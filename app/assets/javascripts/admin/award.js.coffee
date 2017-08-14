showHideItems = (selectedVal) ->
  aprovedContentContainer = '.aproved-content'
  questionNumberContainer = '.question-number'
  contentNumberContainer = '.content-number'

  if (selectedVal == 'test')
    $(aprovedContentContainer).hide()
    $(contentNumberContainer).hide()
    $(questionNumberContainer).show()

  if (selectedVal == 'content')
    $(aprovedContentContainer).show()
    $(contentNumberContainer).hide()
    $(questionNumberContainer).hide()

  if (selectedVal == 'personalized')
    $(contentNumberContainer).show()
    $(questionNumberContainer).hide()

  if (selectedVal == 'all')
    $(contentNumberContainer).hide()
    $(questionNumberContainer).hide()

enableSelectorEvents = ->
  categorySelector = '.category-selector'
  aprovedContentSelector = '.aproved-content-selector'
  selectedVal = $("select option:selected").val()
  showHideItems(selectedVal)

  $(categorySelector).change (e, data) ->
    showHideItems(data.selected)

  $(aprovedContentSelector).change (e, data) ->
    showHideItems(data.selected)

  return

$(document).on 'ready page:load', enableSelectorEvents
