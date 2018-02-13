Polymer
  is: 'moi-quiz-card-content'
  properties:
    authToken: String
    levelsPlaceholder: String
    studentsPlaceholder: String
    levelsApi: String
    studentsApi: String
    questionsApi: String
    quizzesApi: String
  ready: ->
    this.levels = []
    this.students = []
    this.questions = []
    this.loading = true
    this.btnText = 'Enviar'
    this.btnSendText = this.btnText
    this.btnSendingText = 'Enviando..'
    $(this.$.btnsend).addClass 'disabled'
    this.apiParams =
      level_quiz_id: '',
      client_id: ''

    that = this
    levelsAjax = $.ajax
      url: that.levelsApi
      type: 'GET'

    studentsAjax = $.ajax
      url: that.studentsApi
      type: 'GET'

    $.when(levelsAjax, studentsAjax).then((res1, res2) ->
      if res1[0].data
        that.levels = that.formatData(res1[0].data)
      if res2[0].data
        that.students = that.formatStudentData(res2[0].data)

      that.loading = false
    )
    return

  onLevelSelected: (e, val) ->

    item = this.levels.find((item) ->
      return item.id is parseInt(val)
    )
    this.apiParams.level_quiz_id = val
    content_ids = item.content_ids
    this.enableSendButton()
    that = this
    $.ajax
      url: that.questionsApi
      type: 'GET'
      data:
        content_ids: content_ids
      success: (res) ->
        that.questions = res.data
        return
    return

  onStudentSelected: (e, val) ->
    this.apiParams.client_id = val
    this.enableSendButton()
    return

  formatData: (items) ->
    return $.map(items, (item) ->
      return {
        id: item.id
        text: item.name
        content_ids: item.content_ids
      }
    )

  formatStudentData: (items) ->
    return $.map(items, (item) ->
      return {
        id: item.id
        text: "#{item.name} (#{item.username})"
      }
    )

  sendQuiz: ->
    that = this
    $(that.$.btnsend).addClass 'disabled'
    that.btnSendText = that.btnSendingText
    $.ajax
      url: that.quizzesApi
      type: 'POST'
      data:
        quiz: that.apiParams
    return

  enableSendButton: ->
    if (this.apiParams.level_quiz_id is '') or (this.apiParams.client_id is '')
      $(this.$.btnsend).addClass 'disabled'
    else
      $(this.$.btnsend).removeClass 'disabled'

