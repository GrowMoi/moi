reportPage = ".container-report"
chart = new Chart()
loading = new Loading()

loadBubbleChart = () ->
  container = '.bubble-chart-container'
  loading.show(container)
  $.get "/tutor/report/time_reading", (res) ->
    data = ChartUtils.formatBubbleChartData(res.data)
    chart.renderBubbleChart
      data: data
      width: 500
      selector: container

    loading.hide(container)

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
      width: 800
      height: 400
      data: data
      selector: container
      margin:
        top: 20
        right: 200
        bottom: 30
        left: 40

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
