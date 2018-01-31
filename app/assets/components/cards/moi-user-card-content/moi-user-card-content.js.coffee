Polymer
  is: 'moi-user-card-content'
  properties:
    usersApi: String
    sendRequestBtnText: String
    sendRequestBtnTitle: String
    sendRequestBtnLoadingText: String
    sendRequestBtnClass: String
    searchValue:
      type: String,
      value: ''
    count:
      type: Number
      value: 1
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
    mainContext = this
    mainContext.loading = true
    usersApi = @usersApi
    $(@$.btnsend).addClass('disabled')
    $(@$.listcontainer).scrollTop(0)
    $(@$.listcontainer).scroll(@debounce((e)->
      mainContext.onListScroll(e, mainContext)
    , 200))
    $.ajax
      url: usersApi
      type: 'GET'
      data:
        page: mainContext.count
      success: (res) ->
        mainContext.loading = false
        mainContext.clients = res.data
        return

  onListScroll: (e, mainContext) ->
    usersApi = mainContext.usersApi
    elem = $(e.currentTarget)
    diff = elem[0].scrollHeight - elem.scrollTop()
    scrollBottom = diff is elem.outerHeight()
    if scrollBottom
      mainContext.loading = true
      mainContext.count++
      $.ajax
        url: usersApi
        type: 'GET'
        data:
          page: mainContext.count
          search: mainContext.searchValue
        success: (res) ->
          mainContext.loading = false
          mainContext.clients = mainContext.clients.concat(res.data)
          return
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

  debounce: (func, delay) ->
    inDebounce = undefined
    ->
      context = this
      args = arguments
      clearTimeout inDebounce
      inDebounce = setTimeout((->
        func.apply context, args
        return
      ), delay)
      return

  onInputEnter: (e, value) ->
    mainContext = this
    @searchValue = value
    usersApi = @usersApi
    mainContext.count = 1
    mainContext.clients = []
    mainContext.loading = true
    $.ajax
      url: usersApi
      type: 'GET'
      data:
        page: mainContext.count
        search: value
      success: (res) ->
        mainContext.loading = false
        mainContext.clients = res.data
        return
    return
