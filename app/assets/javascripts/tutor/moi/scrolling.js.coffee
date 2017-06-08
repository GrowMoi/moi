$(document).on 'ready page:load', ->
  $wrapper = $('.list-clients-wrapper')
  $wrapper.infinitePages
    # debug: true
    buffer: 200
    context: '.list-clients-wrapper'
  $wrapper.find(".pagination").hide()
