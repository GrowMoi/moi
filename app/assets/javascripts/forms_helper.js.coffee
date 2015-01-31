formsHelper =
  init: ->
    $(".field:not(.field_bootstrap)").each ->
      $(this).addClass("field_bootstrap form-group")

    $("input:submit:not(.button_bootstrap)").each ->
      $(this).addClass("button_bootstrap btn btn-success")

jQuery formsHelper.init
