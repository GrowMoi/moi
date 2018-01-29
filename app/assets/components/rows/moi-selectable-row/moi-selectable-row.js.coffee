Polymer
  is: 'moi-selectable-row'
  properties:
    name: String
    username: String
    imgSelector: String
    imgAvatarActive: String
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
      @imgAvatar = @imgAvatarActive
    else
      @imgAvatar = '/assets/client_avatar_inactive.png'
    @fire 'row-selected', @studentId
    return
