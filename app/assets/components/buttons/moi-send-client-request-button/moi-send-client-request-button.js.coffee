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
    that = this
    that.prevText = that.text
    that.text = that.loadingText
    $(that.$.btnsend).addClass 'disabled'
    $.ajax
      url: that.sendRequestApi
      type: 'POST'
      data:
        ids: that.ids
      success: (res) ->
        $(that.$.btnsend).removeClass 'disabled'
        that.text = that.prevText
        that.fire 'user-request-sent'
        return
    return
