class window.Loading
  show : (elem) ->
    $(elem).children().hide()
    $(elem).append( '<img src="/assets/loading.svg" class="loading">')
    return

  hide : (elem) ->
    $(elem).find('.loading').remove()
    $(elem).children().show()
    return
