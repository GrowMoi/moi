reportPage = ".container-report"
chart = new Chart()
loading = new Loading()

loadBubbleChart = () ->
  backendData = [
    {
      'user_id': 15
      'value': 5
      'name': 'User5'
    }
    {
      'user_id': 11
      'value': 26
      'name': 'User1'
    }
    {
      'user_id': 12
      'value': 33
      'name': 'User2'
    }
    {
      'user_id': 13
      'value': 56
      'name': 'User3'
    }
    {
      'user_id': 14
      'value': 10
      'name': 'User4'
    }
    {
      'user_id': 4
      'value': 33
      'name': 'User6'
    }
    {
      'user_id': 2
      'value': 56
      'name': 'User7'
    }
    {
      'user_id': 7
      'value': 10
      'name': 'User8'
    }
  ]
  container = '.progress-chart-container'
  data = ChartUtils.formatBubbleChartData(backendData)
  chart.renderBubbleChart
    data: data
    selector: container


loadCharts = ->
  if $(reportPage).length > 0
    userId = getParam('user_id')
    loadDonutChart(userId)
    loadBarChart()
    loadSingleBarCharts(userId)
    loadBubbleChart()
  return

loadDonutChart = (userId) ->
  container = '.donut-chart-container'
  loading.show(container)
  $.get "/tutor/report/root_contents_learnt", user_id: userId, (res) ->
    data = ChartUtils.formatDonutChartData(res.data)
    chart.renderDonutChart
      width: 500
      height: 300
      data: data
      selector: container

    loading.hide(container)
  return

loadBarChart = ->
  container = '.bar-chart-container'
  loading.show(container)
  $.get "/tutor/report/tutor_users_contents_learnt", (res) ->
    data = ChartUtils.formatBarChartData(res.data)
    chart.renderBarChart
      width: 900
      height: 300
      data: data
      selector: container

    loading.hide(container)
  return

loadSingleBarCharts = (userId) ->
  container = '.analytics-chart-container'
  loading.show(container)
  fields = [
    "used_time",
    "total_neurons_learnt",
    "total_content_readings",
    "average_used_time_by_content",
    "total_notes",
    "images_opened_in_count"
  ]
  $.get "/tutor/report/analytics_details", user_id: userId, fields: fields, (res) ->
    data = ChartUtils.formatSingleBarChartData(res.data)
    width = 100
    height = 450
    commonMargin =
      top: 20
      right: 0
      bottom: 90
      left: 0

    chart.renderSingleBarChart
      selector: '.used-time-chart'
      type: 'time'
      data: data.used_time
      width: width
      className: 'fill-used-time-chart'
      height: height
      showYaxis: false
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.total-neurons-learnt-chart'
      type: 'number'
      data: data.total_neurons_learnt
      width: width
      className: 'fill-total-neurons-learnt-chart'
      height: height
      showYaxis: false
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.total-content-readings-chart'
      type: 'number'
      data: data.total_content_readings
      width: width
      className: 'fill-total-content-readings-chart'
      height: height
      showYaxis: false
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.average-used-time-by-content-chart'
      type: 'time'
      data: data.average_used_time_by_content
      width: width
      className: 'fill-average-used-time-by-content-chart'
      height: height
      showYaxis: false
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.total-notes-chart'
      type: 'number'
      data: data.total_notes
      width: width
      className: 'fill-total-notes-chart'
      height: height
      showYaxis: false
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.images-opened-in-count-chart'
      type: 'number'
      data: data.images_opened_in_count
      width: width
      className: 'fill-images-opened-in-count-chart'
      height: height
      showYaxis: false
      margin: commonMargin

    loading.hide(container)
    return

getParam = (name) ->
  (location.search.split(name + '=')[1] or '').split('&')[0]

$(document).on "ready page:load", loadCharts
