Polymer
  is: 'moi-user-card-content'
  properties:
    usersApi: String
    sendRequestBtnText: String
    sendRequestBtnTitle: String
    sendRequestBtnLoadingText: String
    sendRequestBtnClass: String
    sendRequestBtnApi: String
    rowImgActive: String
    rowImgInactive: String
    rowImgCheck: String
    inputIconImage: String
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
    @init()
    return

  init: ->
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
        mainContext.totalItems = res.meta.total_items
        return

  onListScroll: (e, mainContext) ->
    usersApi = mainContext.usersApi
    elem = $(e.currentTarget)
    diff = elem[0].scrollHeight - elem.scrollTop()
    scrollBottom = Math.round(diff) <= elem.outerHeight()
    existsData = mainContext.clients.length < mainContext.totalItems

    if scrollBottom and existsData
      mainContext.loading = true
      mainContext.count++
      $(mainContext.$.listcontainer).addClass('stop-scrolling')
      $.ajax
        url: usersApi
        type: 'GET'
        data:
          page: mainContext.count
          search: mainContext.searchValue
        success: (res) ->
          mainContext.loading = false
          mainContext.clients = mainContext.clients.concat(res.data)
          mainContext.totalItems = res.meta.total_items
          $(mainContext.$.listcontainer).removeClass('stop-scrolling')
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
    mainContext.resetParams()
    $(mainContext.$.btnsend).addClass('disabled')
    $.ajax
      url: usersApi
      type: 'GET'
      data:
        page: mainContext.count
        search: value
      success: (res) ->
        mainContext.loading = false
        mainContext.clients = res.data
        mainContext.totalItems = res.meta.total_items
        return
    return

  onUserRequestSent: (e) ->
    @resetParams()
    @init()
    return

  resetParams: ->
    @count = 1
    @clients = []
    @loading = true
    @clientsSelected = []
    return
