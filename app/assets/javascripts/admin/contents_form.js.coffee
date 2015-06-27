# automatically adds level and kind to content form
$(document).on "nested:fieldAdded:contents", (e) ->
  $contentForm = e.field
  $target = $(e.currentTarget.activeElement)
  $contentForm.find("input.content-level")
              .val $target.data("level")
  $contentForm.find("input.content-kind")
              .val $target.data("kind")

# media uploader
$(document).on "click", ".content-media-uploader", (e) ->
  $this = $(this)
  $input = $this.parent().find("input[type='file']")
  $input.trigger "click"
  $input.on "change", (e) ->
    name = if typeof(e.target.files[0]) is "object"
      e.target.files[0].name
    else
      ""
    $this.nextAll(".content-media-name").text(name)
    $input.off "change"
