Polymer
  is: 'moi-send-notifications-card-content'
  properties:
    authToken: String
    sendNotificationApi: String
    currentTime:
      type: Number
      default: Date.now()
    notificationTitle:
      type: String
      default: ''
      observer: 'enableSendButton'
  ready: ->
    currentTime = Date.now()
    this.buildInputFileName(currentTime)
    $(this.$.btnsend).addClass 'disabled'

  onSelectFile: (e, val) ->
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

  enableSendButton: (newVal) ->
    if newVal.length > 0
      $(this.$.btnsend).removeClass 'disabled'
    else
      $(this.$.btnsend).addClass 'disabled'
