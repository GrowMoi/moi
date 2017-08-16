showHideItemsCategories = (selectedVal) ->
  aprovedContentContainer = '.aproved-content'

  if (selectedVal == 'test')
    $(aprovedContentContainer).hide()

  if (selectedVal == 'content')
    $(aprovedContentContainer).show()

  return

showHideItemsAprovedContent = (selectedVal) ->
  testNumberContainer = '.test-number'
  contentNumberContainer = '.content-number'

  if (selectedVal == 'personalized')
    $(contentNumberContainer).show()
    $(testNumberContainer).hide()

  if (selectedVal == 'all')
    $(contentNumberContainer).hide()
    $(testNumberContainer).hide()

  return

enableSelectorEvents = ->
  categorySelector = '.category-selector'
  aprovedContentSelector = '.aproved-content-selector'
  categoryVal = $(".achievement-categories select option:selected").val()
  aprovedContentVal = $(".aproved-content select option:selected").val()

  showHideItemsCategories(categoryVal)
  showHideItemsAprovedContent(aprovedContentVal)

  $(categorySelector).change (e, data) ->
    showHideItemsCategories(data.selected)

  $(aprovedContentSelector).change (e, data) ->
    showHideItemsAprovedContent(data.selected)

  return

$(document).on 'ready page:load', enableSelectorEvents
