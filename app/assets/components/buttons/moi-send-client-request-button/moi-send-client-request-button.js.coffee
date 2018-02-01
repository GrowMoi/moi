Polymer
  is: 'moi-send-client-request-button'
  properties:
    text: String
    loadingText: String
    sendRequestApi: String
    ids:
      type: Array
        value: ->
          return []
  onClick: ->
    mainContext = this
    mainContext.prevText = mainContext.text
    mainContext.text = mainContext.loadingText
    $(mainContext.$.btnsend).addClass 'disabled'
    $.ajax
      url: mainContext.sendRequestApi
      type: 'POST'
      data:
        ids: mainContext.ids
      success: (res) ->
        $(mainContext.$.btnsend).removeClass 'disabled'
        mainContext.text = mainContext.prevText
        mainContext.fire 'user-request-sent'
        return
    return
