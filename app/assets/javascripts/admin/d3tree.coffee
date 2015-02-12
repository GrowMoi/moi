setChildren = (neuron, neuron_parents) ->
  if neuron.children
    for child in neuron.children
      child.children = neuron_parents[child.id]
      setChildren(child, neuron_parents)

created3tree = ->
  jsonRoot = "neurons"

  width = $("#tree_data").width()
  height = width
  tree = d3.layout.tree().size([
    width,
    height - 30
  ])
  diagonal = d3.svg.diagonal().projection((d) ->
    [
      d.x
      d.y
    ]
  )

  # {
  #   id: 1,
  #   name: "Neurona",
  #   parent_id: 3
  # }

  svg = d3.select('#tree_data')
           .append('svg')
           .attr('width', width)
           .attr('height', height)
           .attr('viewBox',"0 0 #{width} #{height}")
           .attr('preserveAspectRatio', 'xMidYMid')
           .append('g')
           .attr('transform', 'translate(0,10)')

  d3.json '/admin/neurons.json', (error, response) ->

    neurons = response[jsonRoot]

    root = neurons.filter((neuron) ->
      neuron.id == response.meta.root_id
    )[0]

    neuron_parents = {"no_parent":[]}
    for neuron in neurons
      if neuron.parent_id
        unless neuron_parents[neuron.parent_id]
          neuron_parents[neuron.parent_id] = []
        neuron_parents[neuron.parent_id].push neuron
      else if neuron.id != response.meta.root_id
        neuron_parents["no_parent"].push(neuron)

    root.children = neuron_parents[root.id]

    setChildren(root, neuron_parents)

    nodes = tree.nodes(root)
    links = tree.links(nodes)
    link = svg.selectAll('path.link')
               .data(links)
               .enter()
               .append('path')
               .attr('class', 'link')
               .attr('d', diagonal)
    node = svg.selectAll('g.node')
               .data(nodes)
               .enter()
               .append('g')
               .attr('class', 'node')
               .attr('transform', (d) ->
                 'translate(' + d.x + ',' + d.y + ')'
                )
    node.append('circle').attr 'r', 4.5
    node.append('text').attr('dx', (d) ->
      if d.children then -8 else 8
    ).attr('dy', 3).attr('text-anchor', (d) ->
      if d.children then 'end' else 'start'
    ).text (d) ->
      d.title

    # sin padre
    v_space = 15
    svg.append("g").attr("class", "no-parents")
    no_parents = svg.selectAll("g.no-parents")
                 .data(neuron_parents["no_parent"])
                 .enter()
                 .append("g")
                 .attr("class", "node")
                 .attr("transform", (d, i) ->
                   y = i * v_space
                   "translate(#{width - 10}, #{y})"
                  )
    no_parents.append("circle").attr "r", 4.5
    no_parents.append("text").text((d) ->
      d.title
    ).attr("dx", 8).attr("dy", 3)

    return

  d3.select(self.frameElement).style 'height', height + 'px'

$(document).on "ready page:load", created3tree

$(window).on "resize", ->
  $chart = $("#tree_data svg")
  aspect = 1 # square ATM
  targetWidth = $chart.parent().width()
  $chart.attr("width", targetWidth)
  $chart.attr("height", targetWidth / aspect)
