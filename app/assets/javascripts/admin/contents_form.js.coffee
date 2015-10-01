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
    return unless typeof(e.target.files[0]) is "object"
    
    reader = new FileReader()
    reader.onload = ->
      img = reader.result
      $preview = $ "<a />",
                   href: img,
                   target: "_blank",
                   html: $("<img />", src: img)
      $preview.append(e.target.files[0].name)
      $this.nextAll(".content-media-name-on-form").html $preview

    reader.readAsDataURL(e.target.files[0])
    $input.off "change"
