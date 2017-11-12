applyChosen = ->
  $("#content_recommendations").chosen allow_single_deselect: true, disable_search_threshold: 10

$(document).on "ready page:load", applyChosen
