Polymer
  is: 'moi-user-card-content'
  properties:
    usersApi: String
    sendRequestBtnText: String
    sendRequestBtnTitle: String
    sendRequestBtnLoadingText: String
    sendRequestBtnClass: String
    loading:
      type: Boolean
      value: false
    clients:
      type: Array
      value: ->
        return []
    clientsSelected:
      type: Array
      value: ->
        return []

  ready: ->
    manager = this
    manager.loading = true
    manager = this
    $(@$.btnsend).addClass('disabled')
    $.ajax
      url: @usersApi
      type: 'GET'
      success: (res) ->
        manager.loading = false
        manager.clients = res.data
        return
  onRowSelectedHandler: (e, data) ->
    index = @clientsSelected.indexOf(data)
    if index isnt -1
      @splice('clientsSelected', index, 1)
    else
      @push('clientsSelected', data)
    if @clientsSelected.length > 0
      $(@$.btnsend).removeClass('disabled')
    else
      $(@$.btnsend).addClass('disabled')

    return
