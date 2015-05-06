class KnowledgeSearch
  elId: ".knowledge-search-form"

  constructor: ->
    @formListener()

  formListener: ->
    $(document).on "submit", @elId, @formSubmitted

  init: ->
    # only show modal
    @$el = $(@elId)
    @$el.modal()

  formSubmitted: (e) =>
    $form = $(e.target)
    $.post $form.attr("action"), $form.serialize(), @gotResponse
    false

  gotResponse: (data) =>
    console.log data


knowledgeSearch = new KnowledgeSearch()

$(document).on "click", "#knowledge-search-btn", (e) ->
  knowledgeSearch.init()
  false
