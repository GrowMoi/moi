Polymer
  is: 'moi-student-card-content'
  properties:
    downloadBtnHref: String
    downloadBtnText: String
    downloadBtnTitle: String
    downloadSelectiveBtnText: String
    downloadSelectiveBtnTitle: String
    downloadBtnFilename: String
    downloadBtnLoadingText: String
    downloadBtnMimeType: String
    downloadBtnClass: String
    rowImgActive: String
    rowImgInactive: String
    rowImgCheck: String
    studentsApi: String
    reportBtnTitle: String
    loading:
      type: Boolean
      value: false
    students:
      type: Array
      value: ->
        return []
    studentsSelected:
      type: Array
      value: ->
        return []

  ready: ->
    manager = this
    $(@$.btnSelectiveDownload).addClass('disabled')
    manager.loading = true
    $.ajax
      url: @studentsApi
      type: 'GET'
      success: (res) ->
        manager.loading = false
        manager.students = res.data
        return
  onRowSelectedHandler: (e, data) ->
    index = @studentsSelected.indexOf(data)
    if index isnt -1
      @splice('studentsSelected', index, 1)
    else
      @push('studentsSelected', data)

    if @studentsSelected.length > 0
      $(@$.btnSelectiveDownload).removeClass('disabled')
    else
      $(@$.btnSelectiveDownload).addClass('disabled')
    return
