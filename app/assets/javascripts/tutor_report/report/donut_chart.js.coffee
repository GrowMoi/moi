reportPage = ".container-report"

loadDonutChartData = ->

  if $(reportPage).length > 0
    container = '.donut-chart-container'
    userId = getParam('user_id')
    showLoading(container)
    $.get "/tutor/report/root_contents_learnt", user_id: userId, (res) ->
      hideLoading(container)
      renderDonutChart(res.data, container)
    return

getParam = (name) ->
  (location.search.split(name + '=')[1] or '').split('&')[0]

renderDonutChart = (data, selector) ->
  width = 500
  height = 300
  radius = Math.min(width, height) / 2
  legendRectSize = 15
  legendSpacing = 4
  legendRightPadding = 12
  legendVerticalPadding = -15
  legendVerticalHeight = -20
  maxValue = getMaxValue(data)
  arc = d3.svg.arc()
          .outerRadius(radius - 10)
          .innerRadius(radius - 70)

  pie = d3.layout.pie()
          .sort(null)
          .value((d) ->
            d.total_contents_learnt
          )

  svg = d3.select(selector)
          .append('svg')
          .attr('width', width)
          .attr('height', height)
          .append('g')
          .attr('transform', 'translate(' + width / 3 + ',' + height / 2 + ')')

  g = svg.selectAll('.arc')
          .data(pie(data))
          .enter()
          .append('g')
          .attr('class', 'arc')

  g.append('path')
          .attr('d', arc)
          .attr('class', addClass)
          .style 'fill', generateColor

  g.append('text')
          .attr('transform', (d) ->
            'translate(' + arc.centroid(d) + ')'
          ).attr('dy', '.35em')
          .attr('class', 'fill-text')
          .text (d) ->
            res = d.data.total_contents_learnt * 100 / maxValue
            res.toFixed(2) + '%'

  legend = svg.selectAll('.legend')
              .data(data)
              .enter()
              .append('g')
              .attr('class', 'legend')
              .attr('transform', (d, i) ->
                dataHeight = legendRectSize + legendSpacing
                offset = dataHeight + i
                horz = legendRightPadding * legendRectSize
                vert = i * legendVerticalHeight - legendVerticalPadding
                'translate(' + horz + ',' + vert + ')'
              )

  legend.append('rect')
        .attr('width', legendRectSize)
        .attr('height', legendRectSize)
        .attr('class', addClass)
        .style('fill', generateColor)
        .style('stroke', generateColor)

  legend.append('text')
        .attr('x', legendRectSize + legendSpacing)
        .attr('y', legendRectSize - legendSpacing).text (d) ->
          d.title
  return

addClass = (d, i) ->
  'fill-color-' + i

generateColor = ->
  rgbStr = getComputedStyle(this).getPropertyValue('color')
  rgb = d3.rgb(rgbStr)
  rgb

type = (d) ->
  d.title = +d.title
  d

getMaxValue = (data) ->
  data.map((d) ->
    d.total_contents_learnt
  ).reduce (prevVal, newVal) ->
    prevVal + newVal

showLoading = (elem) ->
  $(elem).children().hide()
  $(elem).append( '<img src="/assets/loading.svg" class="loading">')
  return

hideLoading = (elem) ->
  $(elem).find('.loading').remove()
  $(elem).children().show()
  return

$(document).on "ready page:load", loadDonutChartData
