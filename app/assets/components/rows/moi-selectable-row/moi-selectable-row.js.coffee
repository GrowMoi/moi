Polymer
  is: 'moi-selectable-row'
  properties:
    name: String
    username: String
    imgSelector: String
    imgAvatar: String
    imgAvatarActive: String
    imgAvatarInactive: String
    selected:
      type: Boolean
      value: false
    studentId: String
  ready: ->
    @imgAvatar = @imgAvatarInactive
    return
  selectRow: ->
    @selected = !@selected
    if @selected
      @imgAvatar = @imgAvatarActive
    else
      @imgAvatar = @imgAvatarInactive
    @fire 'row-selected', @studentId
    return
