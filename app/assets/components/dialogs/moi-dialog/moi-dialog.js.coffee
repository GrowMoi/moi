Polymer
  is: 'moi-dialog'
  properties:
    title:
      type: String
      default: ''
    width:
      type: Number
      default: 300
  ready: ->
    that = this
    that.dialogWidth = "width: #{that.width}px"
    $(that).css
      position: 'fixed'
      zIndex: '1031'
      left: (($(window).width() - $(that).outerWidth()) / 2) - (that.width / 2)
      top: (($(window).height() - $(that).outerHeight()) / 2) - 100

    $(that).hide()

  closeDialog: ->
    $(this).hide()
