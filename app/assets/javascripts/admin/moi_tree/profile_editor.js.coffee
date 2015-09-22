class ProfileEditorTree
  constructor: (selector) ->
    @$tree = $(selector)
    @listenForClicks()

  listenForClicks: ->
    $(document).on "moiTree:nodeClicked", (e, node) ->
      console.log node
      console.log "should be painted"
      # d3.select(node).stroke "yellow"
      false

treeSelector = "#tree-for-profile-editor"
$(document).on "ready page:load", ->
  if $(treeSelector).length > 0
    new ProfileEditorTree(treeSelector)
