$(document).on 'ready page:load', ->
  $wrapper = $('.list-dashboard-clients-wrapper')
  $wrapper.infinitePages
    # debug: true
    buffer: 300
    context: '.list-dashboard-clients-wrapper'
  $wrapper.find(".pagination").hide()
