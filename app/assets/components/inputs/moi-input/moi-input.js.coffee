Polymer
  is: 'moi-input'
  properties:
    textValue:
      type: String
      value: ''

  checkForEnter: (e) ->
    if e.keyCode is 13
      @fire 'press-enter', @textValue

