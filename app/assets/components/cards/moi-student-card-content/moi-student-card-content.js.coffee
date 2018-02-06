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

  ready: ->
    this.students = []
    this.studentsSelected = []
    $(this.$.btnSelectiveDownload).addClass('disabled')
    this.loading = true
    that = this
    $.ajax
      url: this.studentsApi
      type: 'GET'
      success: (res) ->
        that.loading = false
        that.students = res.data
        return

  onRowSelectedHandler: (e, data) ->
    index = this.studentsSelected.indexOf(data)
    if index isnt -1
      this.splice('studentsSelected', index, 1)
    else
      this.push('studentsSelected', data)

    if this.studentsSelected.length > 0
      $(this.$.btnSelectiveDownload).removeClass('disabled')
    else
      $(this.$.btnSelectiveDownload).addClass('disabled')
    return
