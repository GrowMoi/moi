isFirefox = navigator.userAgent.indexOf("Firefox") != -1

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
    d3.json @path, @gotNeurons

  gotNeurons: (error, response) =>
    console.error(error) if error

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
    @shownNeurons = @neurons

    @drawLinks()
    @drawNeurons()
    @drawWithoutParent()

  drawNeurons: ->
    self = this
    neuron = @svg.selectAll("g.node")
                  .data(@shownNeurons)
                  .enter()
                  .append("g")
                  .attr("class", "node")
                  .attr("transform", (d) ->
                    "translate(#{d.x},#{d.y})"
                  )
    neuron.append("circle")
          .attr("r", 4.5)
          .style("fill", (d) ->
            if d._children then "lightsteelblue" else "#fff"
          ).on "click", (node) =>
            @toggleNode(node)

    neuron.append('text')
          .attr('dx', -8)
          .attr('dy', 3)
          .attr('text-anchor', "end")
          .text((d) ->
            d.title
          ).on "mouseenter", (node) ->
            self.showDetails(node, this)

  drawLinks: ->
    # re-calculate tree position
    @tree.nodes(@rootNeuron)

    links = @tree.links(@shownNeurons)
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
    self = this
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
    no_parents.append("circle").attr "r", 4.5
    no_parents.append("text")
               .attr("dx", 8)
               .attr("dy", 3)
               .text((d) ->
                 d.title
                )
               .on "mouseenter", (node) ->
                 self.showDetails(node, this)

  setChildren: (neuron) ->
    neuron.children = @neuron_parents[neuron.id]
    if neuron.children
      for child in neuron.children
        @setChildren(child)

  hideChildren: (node) ->
    node.hidden = true
    return unless node.children
    node._children = node.children
    node.children = null
    for child in node._children
      @hideChildren(child)
    null

  showChildren: (node) ->
    node.hidden = false
    return unless node._children
    node.children = node._children
    node._children = null
    for child in node.children
      @showChildren(child)
    null

  filterShownNeurons: ->
    @shownNeurons = @neurons.filter (neuron) ->
      !neuron.hidden

  toggleNode: (node) ->
    if node.children
      @hideChildren(node)
      node.hidden = false
    else
      @showChildren(node)
    @filterShownNeurons()

    d3.select(@selector).html("")

    @draw()

  draw: ->
    @createD3Elements()
    @drawSVG()
    @drawLinks()
    @drawNeurons()
    @drawWithoutParent()

  showDetails: (node, text) ->
    $popover = $(".popover")
    # format:
    $popover.find(".popover-title").html(node.title)
    $newChildLink = $popover.find(".new-child-link")
    if node.parent_id or node.id == @rootNeuron.id
      $newChildLink.show()
                   .attr("href", "/admin/neurons/new?parent_id=#{node.id}")
    else
      $newChildLink.hide()
    $popover.find(".edit-link")
            .attr("href", "/admin/neurons/#{node.id}/edit")

    $text = $(text)
    position = $text.position()
    left = if isFirefox then position.left - 30 else position.left

    # position box itself
    $popover.removeClass("hidden")
            .hide()
            .fadeIn(300)
            .css(
              position: "absolute",
              left: left,
              top: position.top + 10
            )

    # move arrow
    leftOffset = parseInt($text.css("width")) / 2
    arrowPositionLeft = if leftOffset < 14 then 14 else leftOffset
    $popover.find(".arrow")
            .css(
              position: "absolute",
              left: arrowPositionLeft
            )

$(document).on "ready page:load", ->
  if $("#moi_tree").length > 0
    new MoiTree("#moi_tree")

hidePopover = ->
  $(".popover").addClass("hidden")

# close popover
$(document).on "click", ".popover .close", hidePopover
