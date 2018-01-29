Polymer
  is: 'moi-send-client-request-button'
  properties:
    text: String
    loadingText: String
    ids:
      type: Array
        value: ->
          return []
  onClick: ->
    @prevText = @text
    @text = @loadingText
    $(@$.btnsend).addClass 'disabled'
    $.ajax
      url: @href
      type: 'GET'
      data:
        ids: @ids
      success: (res) ->
        return
    return
