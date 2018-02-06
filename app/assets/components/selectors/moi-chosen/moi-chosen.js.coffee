Polymer
  is: 'moi-chosen'
  properties:
    items:
      type: Array
      value: ->
        return []
    placeholder: String
  observers: ['updateChosen(items.*)']

  updateChosen: (items)->
    that = this
    if items.value.length > 0
      this.async(->
        $(that.$.chosenselector).chosen({
          no_results_text: 'Oops, nothing found!',
          width: '100%'
        }).change( (e, val) ->

          key = Object.keys(val)[0]

          if key is 'selected'
            that.fire 'item-selected', val[key]

          if key is 'deselected'
            that.fire 'item-deselected', val[key]

        )
      )
    return



