Polymer
  is: 'moi-select'
  properties:
    items:
      type: Array
      value: ->
        return []
    placeholder: String
    name:
      type: String
      default: ''
  ready: ->
    that = this
    $(that.$.selector).on 'change', (e) ->
      val = $(e.target).val()
      that.fire 'item-selected', val
