Polymer
  is: 'moi-recommendation-card-content'
  properties:
    achievementsApi: String
    achievementsPlaceholder: String
    contentsApi: String
    contentsPlaceholder: String
    createRecomendationsApi: String
  ready: ->
    this.achievements = []
    this.contents = []

    this.apiParams =
      tutor_achievement: '',
      content_tutor_recommendations: []

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
    return

  onChoosenItemSelected: (e, val) ->
    this.apiParams.content_tutor_recommendations.push(val)
    return

  onChoosenItemDeselected: (e, val) ->
    index = this.apiParams.content_tutor_recommendations.indexOf(val)
    if index isnt -1
      this.apiParams.content_tutor_recommendations.splice(index, 1)
    return

  sendRecommendation: ->
    this.loading = true
    that = this
    $.ajax
      url: that.createRecomendationsApi
      type: 'POST'
      data:
        tutor_recommendation: this.apiParams
      success: (res) ->
        that.loading = false
        return
    return

  formatData: (items, textParamName) ->
    return $.map(items, (item) ->
      return {
        id:item.id
        text:item[textParamName]
      }
    )
