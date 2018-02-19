Polymer
  is: 'moi-recommendation-card-content'
  behaviors: [TranslateBehavior]
  properties:
    achievementsApi: String
    achievementsPlaceholder: String
    contentsApi: String
    contentsPlaceholder: String
    createRecomendationsApi: String
    authToken: String
  ready: ->
    this.achievements = []
    this.contents = []
    this.btnText = I18n.t('views.tutor.common.send')
    this.btnSendText = this.btnText
    this.btnSendingText = I18n.t('views.submitting')
    $(this.$.btnsend).addClass 'disabled'
    this.apiParams =
      tutor_achievement: '',
      content_tutor_recommendations: []

    this.enableSendButton()

    this.loading = true
    that = this
    achievementsAjax = $.ajax
      url: that.achievementsApi
      type: 'GET'
    contentsAjax = $.ajax
      url: that.contentsApi
      type: 'GET'
    $.when(achievementsAjax, contentsAjax).then((res1, res2) ->
      if res1[0].data
        that.achievements = that.formatData(res1[0].data, 'name')
      if res2[0].data
        that.contents = that.formatData(res2[0].data, 'title')
      that.loading = false
    )

    return

  onItemSelected: (e, val) ->
    this.apiParams.tutor_achievement = val
    this.enableSendButton()
    return

  onChoosenItemSelected: (e, val) ->
    this.apiParams.content_tutor_recommendations.push(val)
    this.enableSendButton()
    return

  onChoosenItemDeselected: (e, val) ->
    index = this.apiParams.content_tutor_recommendations.indexOf(val)
    if index isnt -1
      this.apiParams.content_tutor_recommendations.splice(index, 1)
    this.enableSendButton()
    return

  sendRecommendation: ->
    that = this
    $(that.$.btnsend).addClass 'disabled'
    that.btnSendText = that.btnSendingText
    $.ajax
      url: that.createRecomendationsApi
      type: 'POST'
      data:
        tutor_recommendation: this.apiParams
    return

  formatData: (items, textParamName) ->
    return $.map(items, (item) ->
      return {
        id:item.id
        text:item[textParamName]
      }
    )

  enableSendButton: ->
    if  (this.apiParams.tutor_achievement is '') or
        (this.apiParams.content_tutor_recommendations.length is 0)

      $(this.$.btnsend).addClass 'disabled'
    else
      $(this.$.btnsend).removeClass 'disabled'

  openDialog: ->
    dialog = this.$.dialog
    if $(dialog).is(':hidden')
      this.$.form.reset()
      $(this.$.fileselect).val('')
      $(this.$.imagecontent).children().remove()
      $(dialog).show()
