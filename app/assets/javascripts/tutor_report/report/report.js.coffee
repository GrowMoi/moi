reportPage = ".container-report"
chart = new Chart()
loading = new Loading()

loadCharts = ->
  if $(reportPage).length > 0
    userId = getParam('user_id')
    loadDonutChart(userId)
    loadBarChart()
  return

loadDonutChart = (userId) ->
  container = '.donut-chart-container'
  loading.show(container)
  $.get "/tutor/report/root_contents_learnt", user_id: userId, (res) ->
    loading.hide(container)
    data = Chart.formatDonutChartData(res.data)
    chart.renderDonutChart
      width: 500
      height: 300
      data: data
      selector: container
  return

loadBarChart = ->
  container = '.bar-chart-container'
  loading.show(container)
  $.get "/tutor/report/tutor_users_contents_learnt", (res) ->
    loading.hide(container)
    data = Chart.formatBarChartData(res.data)
    chart.renderBarChart
      width: 900
      height: 300
      data: data
      selector: container
  return

getParam = (name) ->
  (location.search.split(name + '=')[1] or '').split('&')[0]

$(document).on "ready page:load", loadCharts
