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
    manager = this
    manager.prevText = manager.text
    manager.text = manager.loadingText
    manager.button = manager.$['download-button']
    $(manager.button).addClass 'disabled'
    $.ajax
      url: manager.href
      type: 'GET'
      data:
        ids: manager.ids
      success: (res) ->
        manager.download.call manager, res
        return
    return
  download: (res) ->
    manager = this
    file = new Blob([ res ], type: manager.mimeType)
    downloadLink = document.createElement('a')
    downloadLink.download = manager.filename
    downloadLink.href = window.URL.createObjectURL(file)
    downloadLink.style.display = 'none'
    downloadLink.click()
    manager.text = manager.prevText
    $(manager.button).removeClass 'disabled'
    return
