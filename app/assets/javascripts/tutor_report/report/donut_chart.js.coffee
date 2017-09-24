reportPage = ".container-report"

loadDonutChartData = ->

  if $(reportPage).length > 0
    $container = $('.donut-chart-container')
    userId = getParam('user_id')
    NProgress.start()
    $.get "/tutor/report/root_contents_learnt", user_id: userId, (r) ->
      NProgress.done()
    return

getParam = (name) ->
  (location.search.split(name + '=')[1] or '').split('&')[0]


$(document).on "ready page:load", loadDonutChartData
