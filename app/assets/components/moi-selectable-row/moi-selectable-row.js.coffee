Polymer
  is: 'moi-selectable-row'
  properties:
    name: String
    username: String
    imgSelector:
      type: String
      value: '/assets/check_green.png'
    imgAvatar:
      type: String
      value: '/assets/client_avatar_inactive.png'
    selected:
      type: Boolean
      value: false
    studentId: String
  selectRow: ->
    @selected = !@selected
    if @selected
      @imgAvatar = '/assets/client_avatar_green.png'
    else
      @imgAvatar = '/assets/client_avatar_inactive.png'
    @fire 'row-selected', @studentId
    return
