Polymer
  is: 'moi-input'
  properties:
    iconImage: String
    textValue:
      type: String
      value: ''

  checkForEnter: (e) ->
    if e.keyCode is 13
      this.fire 'press-enter', this.textValue

