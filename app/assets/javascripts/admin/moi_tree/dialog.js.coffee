window.moiTree ||= {}

isFirefox = navigator.userAgent.indexOf("Firefox") != -1

class moiTree.TreeDialog
  constructor: (@neuron, @text) ->
    @$popover = $(".popover")
    @positionPopover()
    @setTitle()
    @setShowLink()
    @setNewChildLink()
    @setEditLink()
    @setToggleLink()

  setShowLink: ->
    href = "/admin/neurons/#{@neuron.id}"
    @$popover.find(".show-link")
             .attr("href", href)

  setTitle: ->
    @$popover.find(".popover-title")
             .html(@neuron.title)

  setNewChildLink: ->
    $link = @$popover.find(".new-child-link")
    if @neuron.parent_id or @neuron.id == @rootNeuron.id
      href = "/admin/neurons/new?parent_id=#{@neuron.id}"
      $link.show().attr("href", href)
    else
      $link.hide()

  setEditLink: ->
    href = "/admin/neurons/#{@neuron.id}/edit"
    @$popover.find(".edit-link")
             .attr("href", href)

  setToggleLink: ->
    $deleteLink = @$popover.find(".destroy-link")
    $restoreLink = @$popover.find(".restore-link")
    if @neuron.deleted
      $restoreLink.show()
      $restoreLink.attr("href", "/admin/neurons/#{@neuron.id}/restore")
      $deleteLink.hide()
    else
      $deleteLink.show()
      $deleteLink.attr("href", "/admin/neurons/#{@neuron.id}/delete")
      $restoreLink.hide()

  positionPopover: ->
    $text = $(@text)
    position = $text.position()
    left = if isFirefox then position.left - 30 else position.left

    # position box itself
    @$popover.removeClass("hidden")
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
    @$popover.find(".arrow")
             .css(
               position: "absolute",
               left: arrowPositionLeft
             )

# close popover
$(document).on "click", ".popover .close", ->
  $(".popover").fadeOut(200)
