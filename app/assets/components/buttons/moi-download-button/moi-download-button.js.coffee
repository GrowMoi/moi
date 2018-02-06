Polymer
  is: 'moi-download-button'
  properties:
    href: String
    text: String
    loadingText: String
    filename: String
    mimeType: String
    ids:
      type: Array
        value: ->
          return []
  onClick: ->
    this.prevText = this.text
    this.text = this.loadingText
    this.button = this.$['download-button']
    $(this.button).addClass 'disabled'
    that = this
    $.ajax
      url: that.href
      type: 'GET'
      data:
        ids: that.ids
      success: (res) ->
        that.download.call that, res
        return
    return
  download: (res) ->
    that = this
    file = new Blob([ res ], type: that.mimeType)
    downloadLink = document.createElement('a')
    downloadLink.download = that.filename
    downloadLink.href = window.URL.createObjectURL(file)
    downloadLink.style.display = 'none'
    downloadLink.click()
    that.text = that.prevText
    $(that.button).removeClass 'disabled'
    return
