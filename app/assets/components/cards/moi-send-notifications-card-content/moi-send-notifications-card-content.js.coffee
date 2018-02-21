Polymer
  is: 'moi-send-notifications-card-content'
  behaviors: [TranslateBehavior, StudentBehavior]
  properties:
    authToken: String
    sendNotificationApi: String
    currentTime:
      type: Number
      default: Date.now()
    notificationTitle:
      type: String
      default: ''
      observer: 'enterTitle'
    studentsApi: String
  ready: ->

    this.loading = true
    this.btnsendId = '#btnsend'
    this.formId = '#form'
    this.userIdSelect = ''
    this.title = ''
    that = this
    studentsAjax = $.ajax
      url: that.studentsApi
      type: 'GET'

    $.when(studentsAjax)
      .then((res1) ->
        that.loading = false

        currentTime = Date.now()
        if res1.data
          that.students = that.formatStudentData(res1.data)

        that.async(->
          that.disableBtn(this.btnsendId)
          that.buildInputFileName(currentTime)
        )
    )

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

  enableSendButton: () ->
    if this.title.length > 0 and this.userIdSelect.length > 0
      this.enableBtn(this.btnsendId)
    else
      this.disableBtn(this.btnsendId)

  onStudentSelected: (e, val) ->
    this.userIdSelect = val
    this.enableSendButton()

  enableBtn: (id) ->
    btnSend = Polymer.dom(this.root).querySelector(id)
    $(btnSend).removeClass 'disabled'

  disableBtn: (id) ->
    btnSend = Polymer.dom(this.root).querySelector(id)
    $(btnSend).addClass 'disabled'

  enterTitle: (newVal) ->
    this.title = newVal
    this.enableSendButton()
