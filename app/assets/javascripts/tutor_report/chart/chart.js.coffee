class window.Chart

  #------- Donut Chart -------
  renderDonutChart : (options) ->
    defaults =
      selector: ''
      width: 500
      height: 300
      data: []
    defaults.radius = Math.min(defaults.width, defaults.height) / 2
    settings = $.extend({}, defaults, options)
    legendRectSize = 15
    legendSpacing = 4
    legendRightPadding = 12
    legendVerticalPadding = -15
    legendVerticalHeight = -20
    maxValue = getMaxValue(settings.data)

    arc = d3.svg.arc()
            .outerRadius(settings.radius - 10)
            .innerRadius(settings.radius - 70)

    pie = d3.layout.pie()
            .sort(null)
            .value((d) ->
              d.value
            )

    svg = d3.select(settings.selector)
            .append('svg')
            .attr('width', settings.width)
            .attr('height', settings.height)
            .append('g')
            .attr('transform', 'translate(' + settings.width / 3 + ',' + settings.height / 2 + ')')

    g = svg.selectAll('.arc')
            .data(pie(settings.data))
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
              res = d.data.value * 100 / maxValue
              res.toFixed(2) + '%'

    legend = svg.selectAll('.legend')
                .data(settings.data)
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

  #------- Bar Chart -------
  renderBarChart: (options) ->
    defaults =
      selector: ''
      data: []
      width: 960
      height: 500

    settings = $.extend({}, defaults, options)
    dimensionName = 'label'
    rangeFillClasses = [0, 6]
    margin =
      top: 20
      right: 20
      bottom: 30
      left: 40

    width = settings.width - (margin.left) - (margin.right)
    height = settings.height - (margin.top) - (margin.bottom)

    x0 = d3.scale.ordinal().rangeRoundBands([0, width], .1)
    x1 = d3.scale.ordinal()
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x0).orient('bottom')
    yAxis = d3.svg.axis().scale(y).orient('left').tickFormat(d3.format('.2s'))

    settings.data.forEach (d) ->
      d.categories = [ {
        name: 'id'
        value: +d.value
      } ]
      return

    x0.domain settings.data.map((d) ->
      d.id
    )

    x1.domain([ 'value' ]).rangeRoundBands [0, x0.rangeBand()]

    y.domain [0, d3.max(settings.data, (d) ->
        d3.max d.categories, (d) ->
          d.value
      )
    ]

    svg = d3.select(settings.selector)
            .append('svg')
            .attr('class', 'bar-chart')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    xAxisEl = svg.append('g')
                .attr('class', 'x axis')
                .attr('transform', 'translate(0,' + height + ')')
                .call(xAxis)

    xAxisEl.selectAll('text').text (d) ->
      item = settings.data.find((ud) ->
        ud.id == d
      )
      label = item.label or ''
      label

    yAxisEl = svg.append('g')
                .attr('class', 'y axis')
                .call(yAxis)

    layer = svg.selectAll('.category')
              .data(settings.data)

    containers = layer.enter()
                      .append('g')
                      .attr('class', 'g')
                      .attr('transform', (d) ->
                        'translate(' + x0(d.id) + ',0)'
                      )

    bars = containers.selectAll('rect').data((d) ->
      d.categories
    )

    bars.enter()
        .append('rect')
        .attr('width', x1.rangeBand())
        .attr('x', (d) ->
          x1 d.label
        ).attr('y', (d) ->
          if !isNaN(d.value)
            return y(d.value)
          return
        ).attr('height', (d) ->
          if !isNaN(d.value)
            return height - y(d.value)
          return
        ).attr('class', (d, v, i) ->
          maxVal = rangeFillClasses[1]
          addClassInRange i, maxVal
        ).style 'fill', generateColor

    svg.selectAll('.y.axis')
      .selectAll('.tick line')
      .call(yAxis)
      .attr 'x2', width

  #------- Single Bar Chart -------
  renderSingleBarChart: (options) ->
    defaults =
      selector: ''
      data: {}
      type: 'number'
      width: 500
      height: 300
      showYaxis: true
      margin:
        top: 20
        right: 20
        bottom: 80
        left: 80
    settings = $.extend({}, defaults, options)
    margin = settings.margin
    width = settings.width - (margin.left) - (margin.right)
    height = settings.height - (margin.top) - (margin.bottom)
    type = settings.type
    data = settings.data
    x = d3.scale.ordinal().rangeRoundBands([0, width], .05)
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x).orient('bottom')
    yAxis = d3.svg.axis().scale(y).orient('left')
    svg = d3.select(settings.selector)
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    x.domain [ data.value ]
    y.domain [0, data.maxValue]

    svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', 'translate(0,' + height + ')')
        .call(xAxis)
        .selectAll('text')
        .style('text-anchor', 'end')
        .attr('dx', '-.55em')
        .attr('dy', '.45em')
        .attr('transform', 'rotate(-55)')
        .text (d) ->
          formatTextLabel type, d

    if settings.showYaxis
      svg.append('g')
        .attr('class', 'y axis')
        .call(yAxis)
        .selectAll('text')
        .text (d) ->
          formatTextLabel type, d

    svg.selectAll('bar')
      .data([ data ])
      .enter()
      .append('path')
      .attr('class', settings.className)
      .attr 'd', (d, i) ->
        _x = x(d.value)
        _y = y(d.value)
        _width = x.rangeBand()
        _height = height - y(d.value)
        _radius = 2
        debugger
        rectangle _x, _y, _width, _height, _radius
    return

  #------- Additional Functions -------
  generateColor = ->
    rgbStr = getComputedStyle(this).getPropertyValue('color')
    rgb = d3.rgb(rgbStr)
    rgb

  addClass = (d, i) ->
    'fill-color-' + i

  getMaxValue = (data) ->
    data.map((d) ->
      d.value
    ).reduce (prevVal, newVal) ->
      prevVal + newVal

  addClassInRange = (i, max) ->
    customIndex = getClassIndex(i, max)
    'fill-color-' + customIndex

  getClassIndex = (index, max) ->
    if index > max
      index = index - (max + 1)
      getClassIndex index
    else
      index

  formatTextLabel = (type, d) ->
    if type == 'time'
      return formatTimeLabel(d)
    d

  rectangle = (x, y, width, height, radius) ->
    str1 = 'M' + (x + radius) + ',' + y + 'h' + (width - (2 * radius))
    str2 = 'a' + radius + ',' + radius + ' 0 0 1 ' + radius + ',' + radius
    str3 = 'v' + (height - (2 * radius)) + 'v' + radius + 'h' + (-radius) + 'h'
    str4 = (2 * radius - width) + 'h' + (-radius) + 'v' + (-radius) + 'v'
    str5 = (2 * radius - height) + 'a' + radius + ',' + radius + ' 0 0 1 ' + radius + ',' + (-radius) + 'z'
    debugger
    str1 + str2 + str3 + str4 + str5

  formatTimeLabel = (millisecondsString) ->
    milliseconds = parseInt(millisecondsString)
    if isNaN(milliseconds)
      0
    else
      duration = moment.duration(milliseconds)._data
      finalString = ''
      if duration.years > 0
        finalString += duration.years + 'a:'
      if duration.months > 0
        finalString += duration.months + 'm:'
      if duration.days > 0
        finalString += duration.days + 'd:'
      if duration.hours > 0
        finalString += duration.hours + 'h:'
      if duration.minutes > 0
        finalString += duration.minutes + 'min:'
      mseconds = duration.milliseconds / 1000
      secondsAndMilliseconds = duration.seconds + mseconds
      finalString += Math.round(secondsAndMilliseconds) + 's'
      finalString
