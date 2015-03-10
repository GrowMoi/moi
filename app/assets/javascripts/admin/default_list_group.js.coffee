$(document).on "click", ".default-list-group a", (e) ->
  $this = $(this)
  $this.parent().find("a").removeClass "active"
  $this.addClass "active"
  $this.tab "show"
