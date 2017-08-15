showHideItems = (selectedVal) ->
  aprovedContentContainer = '.aproved-content'
  testNumberContainer = '.test-number'
  contentNumberContainer = '.content-number'

  if (selectedVal == 'test')
    $(aprovedContentContainer).hide()
    $(contentNumberContainer).hide()
    $(testNumberContainer).show()

  if (selectedVal == 'content')
    $(aprovedContentContainer).show()
    $(contentNumberContainer).hide()
    $(testNumberContainer).hide()

  if (selectedVal == 'personalized')
    $(contentNumberContainer).show()
    $(testNumberContainer).hide()

  if (selectedVal == 'all')
    $(contentNumberContainer).hide()
    $(testNumberContainer).hide()

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
