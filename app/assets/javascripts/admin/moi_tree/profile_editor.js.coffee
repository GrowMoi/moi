class ProfileEditorTree
  neuron_ids: []

  constructor: (selector) ->
    @$selector = $(selector)
    @listenForClicks()

  listenForClicks: ->
    $(document).on "moiTree:nodeShown", @markNeuron
    $(document).on "moiTree:nodeHidden", @unMarkNeuron

  markNeuron: (e, neuron) =>
    neuron.marked = true
    @neuron_ids.push neuron.id
    @updateInput()

  unMarkNeuron: (e, neuron) =>
    neuron.marked = false
    index = @neuron_ids.indexOf(neuron.id)
    if index > 0
      @neuron_ids.splice(index, 1)
    @updateInput()

  updateInput: ->
    @$selector.find("#profile_neuron_ids")
              .val @neuron_ids.join(",")

treeSelector = "#tree-for-profile-editor"
$(document).on "ready page:load", ->
  if $(treeSelector).length > 0
    new ProfileEditorTree(treeSelector)
