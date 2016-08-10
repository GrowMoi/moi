reorder_neurons = (newTree) ->
  $.post "/admin/neurons/reorder", tree: newTree, (r) ->
    console.log r

jQuery ->
  $container = $(".sortable-tree")
  $container.sortable
    onDrop: ($item, container, _super) ->
      data = $container.sortable("serialize").get()
      jsonString = JSON.stringify(data, null)
      reorder_neurons jsonString
      _super($item, container)
