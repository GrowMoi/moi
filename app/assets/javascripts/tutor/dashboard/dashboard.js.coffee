dashboardPage = ".container-dashboard"
formId = '#form-new-achievement'
imageContentId = '#content-media-name-on-form'
inputFileId = '#achievement-file-select'
buttonSendForm = '#button_submit_recommendation'
dialogContentId = '#dialog-dashboard-new-achievement'
dialogUpdateAchievementId = '#dialog-dashboard-update-achievement'
dialogMainClass = 'moi-dialog dialog-red dialog-dashboard-new-achievement'
dialogOpenerId = '#button-dialog-dashboard-new-achievement'
dialogUpdateOpenerSelector = '.button-dashboard-edit-achievement'
openReportButtonSelector = '.button-dashboard-open-report'
studentSearchFormId = '#student-search-form'
studentsListId = '#students-list'
achievemetSearchFormId = '#achievemet-search-form'
achievementsListId = '#achievements-list'

fixCloseButton = (elem) ->
  $(elem).closest('.ui-dialog')
         .find('.ui-dialog-titlebar-close')
         .removeClass('ui-dialog-titlebar-close')
         .html '<span class=\'ui-button-icon-primary ui-icon ui-icon-closethick\'></span>'

configRemoveItems = (elem) ->
  $(elem).wrap("<div></div>");
  $buttonRemove = $("<button class='btn image-remove-field'>
                      <span class='glyphicon glyphicon-remove text-danger'></span>
                    </button>")
  $(elem).parent().append($buttonRemove)
  $buttonRemove.on "click", (e) ->
    e.preventDefault()
    cleanFileInputData()

cleanFormData = () ->
  $(formId)[0].reset()
  cleanFileInputData()
  return

cleanFileInputData = () ->
  $(formId).find(inputFileId).val('')
  $(formId).find(imageContentId).children().remove()
  return

evaluateExp = (str, regex) ->
  values = regex.exec(str)
  res = if $.isArray(values) && values[1] then values[1] else null
  return res

addEventHadlerForUserReport = (selector) ->
  $(selector).click((event) ->
    regex = /tutor_student_(\d+)/g;
    userId = evaluateExp(event.target.id, regex)
    origin = window.location.origin
    window.open(origin + "/tutor/report?user_id=#{userId}", '_blank');
    return
  )
  return

addEventHadlerForTutorEditAchievement = (buttonSelector, dialogSelector) ->
  $(buttonSelector).click((event) ->
    regex = /tutor_achievement_(\d+)/g;
    achievementId = evaluateExp(event.target.id, regex)
    $.get "/tutor/dashboard/edit_achievement?id=#{achievementId}", (res) ->
      $(dialogSelector).html(res)
      $(dialogSelector).dialog 'open'
    return
  )
  return

buildDialog = ->
  cleanFormData()
  $(dialogUpdateAchievementId).dialog
    title: $(dialogUpdateOpenerSelector).children()[0].textContent
    autoOpen: false
    closeOnEscape: true
    modal: true
    width: 500
    dialogClass: dialogMainClass
    resizable: false
    open: () ->
      fixCloseButton(this)

  $(dialogContentId).dialog
    title: $(dialogOpenerId).text()
    autoOpen: false
    closeOnEscape: true
    modal: true
    width: 500
    dialogClass: dialogMainClass
    resizable: false
    open: () ->
      cleanFormData()
      fixCloseButton(this)

  $(dialogOpenerId).click ->
    $(dialogContentId).dialog 'open'
    return

  $(studentSearchFormId).on "submit", (e)->
    e.preventDefault()
    value = e.target.elements[1].value
    $.get "/tutor/dashboard/students?search=#{value}", (res) ->
      $(studentsListId).html(res)
      addEventHadlerForUserReport(openReportButtonSelector)
    return

  $(achievemetSearchFormId).on "submit", (e)->
    e.preventDefault()
    value = e.target.elements[1].value
    $.get "/tutor/dashboard/achievements?search=#{value}", (res) ->
      $(achievementsListId).html(res)
      addEventHadlerForTutorEditAchievement(dialogUpdateOpenerSelector, dialogUpdateAchievementId)
    return

  #Load initial events
  addEventHadlerForUserReport(openReportButtonSelector)
  addEventHadlerForTutorEditAchievement(dialogUpdateOpenerSelector, dialogUpdateAchievementId)

  $(formId).find(imageContentId).on "content_media_appended", (e, imageLinkElem) ->
    configRemoveItems(imageLinkElem)
    return

isDashboardPage = ->
    $(dashboardPage).length > 0

loadPage = ->
  if isDashboardPage()
    buildDialog()
  return

$(document).on "ready page:load", loadPage
