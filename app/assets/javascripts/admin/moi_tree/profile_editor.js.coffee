class ProfileEditorTree
  constructor: (selector) ->
    @$tree = $(selector)
    @listenForClicks()

  listenForClicks: ->
    $(document).on "moiTree:nodeClicked", (e, node) ->
      d3node = d3.selectAll('circle').filter((d, i) =>
        if d
          d.id == node.id
      )
      # here we have the node
      # we are updating, the is the reason it not keep yellow or bigger
      d3node.attr('r', 100)
            .style('fill', 'yellow')
            .style('stroke', 'yellow')
      # we can change the color of text if we select d3.selectAll('g') in ln 8
      false

treeSelector = "#tree-for-profile-editor"
$(document).on "ready page:load", ->
  if $(treeSelector).length > 0
    new ProfileEditorTree(treeSelector)
