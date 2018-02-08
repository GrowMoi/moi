Polymer
  is: 'moi-send-notifications-card-content'
  params:
    authToken: String
    sendNotificationApi: String
    currentTime:
      type: Number
      default: Date.now()
  ready: ->
    this.sending = false
    currentTime = Date.now()
    this.buildInputFileName(currentTime)

  testOnChange: (e, val) ->
    currentTime = Date.now()
    this.updateInputFileName(currentTime)

  buildInputFileName: (currentTime) ->
    paramName = 'notification_medium_attributes'
    this.mediaInputName = "notification[#{paramName}][#{currentTime}][media]"
    this.cacheName = "notification[#{paramName}][#{currentTime}][media_cache]"
    return

  updateInputFileName: (currentTime) ->
    this.buildInputFileName(currentTime)
    return
