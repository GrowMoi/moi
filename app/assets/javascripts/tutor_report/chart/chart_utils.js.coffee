class window.ChartUtils
  this.formatBarChartData = (data) ->
    data.map (d) ->
      {
        id: d.user_id
        label: d.name
        value: d.contents_learnt
      }

  this.formatDonutChartData = (data) ->
    data.map (d) ->
      {
        id: d.id
        parentId: d.parent_id
        title: d.title
        value: d.total_contents_learnt
      }

  this.formatSingleBarChartData = (data) ->
    res = {}
    for key of data
      res[key] =
        maxValue: data[key].value
        value: data[key].value
        valueHumanized: if data[key].meta and data[key].meta.value_humanized then data[key].meta.value_humanized else null
    res

  this.formatBubbleChartData = (data) ->
    result = []
    i = 0
    while i < data.length
      row = []
      row.push data[i].name
      row.push data[i].value
      row.push data[i].value_humanized
      result.push row
      i++
    result
