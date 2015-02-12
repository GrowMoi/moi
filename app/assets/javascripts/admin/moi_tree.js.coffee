class MoiTree
  selector: null
  $node: null
  path: null
  width: null
  height: null

  constructor: (@selector) ->
    @$node = $(@selector)
    @path = @$node.data("source")
    @width = @$node.width()
    @height = @width
    @createD3Elements()
    @drawSVG()
    @getNeurons()
    @listenForResize()

  listenForResize: ->
    $(window).on "resize", ->
      $chart = $("#{@selector} svg")
      aspect = 1 # square ATM
      targetWidth = $chart.parent().width()
      $chart.attr("width", targetWidth)
      $chart.attr("height", targetWidth / aspect)

  createD3Elements: ->
    @tree = d3.layout.tree().size([@width, @height-20])

  drawSVG: ->
    @svg = d3.select(@selector)
              .append("svg")
              .attr("width", @width)
              .attr("height", @height)
              .attr('viewBox',"0 0 #{@width} #{@height}")
              .attr('preserveAspectRatio', 'xMidYMid')
              .append('g')
              .attr('transform', 'translate(0,10)')

  getNeurons: ->
    d3.json @path, (error, response) =>
      alert(error) if error
      @gotNeurons(response)

  gotNeurons: (response) ->
    neurons = response.neurons # under `neurons` key in json

    @rootNeuron = neurons.filter((neuron) ->
      neuron.id == response.meta.root_id
    )[0]

    @neuron_parents = { "no_parent":[] }

    for neuron in neurons
      if neuron.parent_id
        unless @neuron_parents[neuron.parent_id]
          @neuron_parents[neuron.parent_id] = []
        @neuron_parents[neuron.parent_id].push neuron
      else if neuron.id != response.meta.root_id
        @neuron_parents["no_parent"].push(neuron)

    @setChildren(@rootNeuron)

    @neurons = @tree.nodes(@rootNeuron)

    @drawLinks()
    @drawNeurons()
    @drawWithoutParent()

  drawNeurons: ->
    neuron = @svg.selectAll("g.node")
                  .data(@neurons)
                  .enter()
                  .append("g")
                  .attr("class", "node")
                  .attr("transform", (d) ->
                    "translate(#{d.x},#{d.y})"
                  )
                  .on "click", $.proxy(@showDetails, @)
    neuron.append("circle").attr "r", 4.5
    neuron.append('text').attr('dx', (d) ->
      if d.children then -8 else 8
    ).attr('dy', 3).attr('text-anchor', (d) ->
      if d.children then 'end' else 'start'
    ).text (d) ->
      d.title

  drawLinks: ->
    links = @tree.links(@neurons)
    diagonal = d3.svg.diagonal().projection((d) ->
      [ d.x, d.y ]
    )
    link = @svg.selectAll("path.link")
                .data(links)
                .enter()
                .append("path")
                .attr("class", "link")
                .attr("d", diagonal)

  drawWithoutParent: ->
    vertical_space = 15
    @svg.append("g").attr("class", "no-parents")
    no_parents = @svg.selectAll("g.no-parents")
                      .data(@neuron_parents["no_parent"])
                      .enter()
                      .append("g")
                      .attr("class", "node")
                      .attr("transform", (d, i) =>
                        y = i * vertical_space
                        "translate(#{@width - 10}, #{y})"
                      )
                      .on "click", $.proxy(@showDetails, @)
    no_parents.append("circle").attr "r", 4.5
    no_parents.append("text")
               .attr("dx", 8)
               .attr("dy", 3)
               .text((d) ->
                 d.title
                )

  setChildren: (neuron) ->
    neuron.children = @neuron_parents[neuron.id]
    if neuron.children
      for child in neuron.children
        @setChildren(child)

  showDetails: (node) ->
    $popover = $(".popover")
    # format:
    $popover.find(".popover-title").html(node.title)
    $newChildLink = $popover.find(".new-child-link")
    if node.parent_id
      $newChildLink.show()
                   .attr("href", "/admin/neurons/new?parent_id=#{node.id}")
    else
      $newChildLink.hide()
    $popover.find(".edit-link")
            .attr("href", "/admin/neurons/#{node.id}/edit")
    $popover.removeClass("hidden")
            .hide()
            .fadeIn(300)
            .css(
              position: "absolute",
              left: event.pageX + 5,
              top: event.pageY - 38
            )

$(document).on "ready page:load", ->
  if $("#moi_tree").length > 0
    new MoiTree("#moi_tree")

# close popover
$(document).on "click", ".popover .close", ->
  $(".popover").addClass("hidden")
