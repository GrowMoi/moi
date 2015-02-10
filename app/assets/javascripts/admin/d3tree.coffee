created3tree = ->
  width = 400
  height = 600
  tree = d3.layout.tree().size([
    height
    width - 160
  ])
  diagonal = d3.svg.diagonal().projection((d) ->
    [
      d.y
      d.x
    ]
  )
  svg = d3.select('#tree_data').append('svg').attr('width', width).attr('height', height).append('g').attr('transform', 'translate(40,0)')
  d3.json '/admin/neurons.json', (error, json) ->
    nodes = tree.nodes(json[0])
    links = tree.links(nodes)
    link = svg.selectAll('path.link').data(links).enter().append('path').attr('class', 'link').attr('d', diagonal)
    node = svg.selectAll('g.node').data(nodes).enter().append('g').attr('class', 'node').attr('transform', (d) ->
      'translate(' + d.y + ',' + d.x + ')'
    )
    node.append('circle').attr 'r', 4.5
    node.append('text').attr('dx', (d) ->
      if d.children then -8 else 8
    ).attr('dy', 3).attr('text-anchor', (d) ->
      if d.children then 'end' else 'start'
    ).text (d) ->
      d.name
    return
  d3.select(self.frameElement).style 'height', height + 'px'

$(document).on "ready page:load", created3tree
