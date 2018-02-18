Polymer
  is: 'moi-user-card-content'
  behaviors: [TranslateBehavior]
  properties:
    usersApi: String
    sendRequestBtnClass: String
    sendRequestBtnApi: String
    rowImgActive: String
    rowImgInactive: String
    rowImgCheck: String
    inputIconImage: String

  ready: ->
    this.searchValue = ''
    this.initValues()
    this.init()
    return

  init: ->
    this.loading = true
    $(this.$.btnsend).addClass('disabled')
    $(this.$.listcontainer).scrollTop(0)
    that = this
    $(this.$.listcontainer).scroll(this.debounce((e)->
      that.onListScroll(e, that)
    , 200))
    $.ajax
      url: that.usersApi
      type: 'GET'
      data:
        page: that.count
      success: (res) ->
        that.loading = false
        that.clients = res.data
        that.totalItems = res.meta.total_items
        return

  onListScroll: (e, that) ->
    elem = $(e.currentTarget)
    diff = elem[0].scrollHeight - elem.scrollTop()
    scrollBottom = Math.round(diff) <= elem.outerHeight()
    existsData = that.clients.length < that.totalItems

    if scrollBottom and existsData
      that.loading = true
      that.count++
      $(that.$.listcontainer).addClass('stop-scrolling')
      $.ajax
        url: that.usersApi
        type: 'GET'
        data:
          page: that.count
          search: that.searchValue
        success: (res) ->
          that.loading = false
          that.clients = that.clients.concat(res.data)
          that.totalItems = res.meta.total_items
          $(that.$.listcontainer).removeClass('stop-scrolling')
          return
    return

  onRowSelectedHandler: (e, data) ->
    index = this.clientsSelected.indexOf(data)
    if index isnt -1
      this.splice('clientsSelected', index, 1)
    else
      this.push('clientsSelected', data)
    if this.clientsSelected.length > 0
      $(this.$.btnsend).removeClass('disabled')
    else
      $(this.$.btnsend).addClass('disabled')

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
    this.searchValue = value
    this.initValues()
    $(this.$.btnsend).addClass('disabled')
    that = this
    $.ajax
      url: that.usersApi
      type: 'GET'
      data:
        page: that.count
        search: value
      success: (res) ->
        that.loading = false
        that.clients = res.data
        that.totalItems = res.meta.total_items
        return
    return

  initValues: ->
    this.count = 1
    this.clients = []
    this.loading = true
    this.clientsSelected = []
    return
