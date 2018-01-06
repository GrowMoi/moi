dashboardPage = ".container-dashboard"
imageContentId = '#content-media-name-on-form'
inputFileId = '#achievement-file-select'
dialogMainClass = 'moi-dialog dialog-red dialog-dashboard-new-achievement'
listDashboardClientsWrapperSelector = '.list-dashboard-clients-wrapper'
clientsSearchFormInputSelector = '#clients-search-form-input'

#button selectors
buttonDialogDashboardNewAchievementSelector = '#button-dialog-dashboard-new-achievement'
buttonDialogDashboardSendRequestSelector = '#button-dialog-dashboard-send-request'
dialogUpdateOpenerSelector = '.button-dashboard-edit-achievement'
openReportButtonSelector = '.button-dashboard-open-report'
buttonDashboardSendRequestSelector = '.button-dashboard-send-request'

#dialog selectors
dialogDashboardNewAchievementSelector = '#dialog-dashboard-new-achievement'
dialogUpdateAchievementId = '#dialog-dashboard-update-achievement'
dialogSendStudentRequestSelector = '#dialog-send-student-request'

#form selectors
studentSearchFormId = '#student-search-form'
achievemetSearchFormId = '#achievemet-search-form'
clientsSearchFormId = '#clients-search-form'

formId = '#form-new-achievement'

#list selectors
studentsListId = '#students-list'
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

addEventHadlerForTutorSendRequest = (buttonSelector) ->
  $(buttonSelector).click((event) ->
    $(this).addClass('disabled')
    regex = /client_(\d+)/g;
    clientId = evaluateExp(event.currentTarget.id, regex)
    $.post "/tutor/dashboard/send_request/?user_id=#{clientId}"
    return
  )
  return

buildDialog = (selector, title, cbOpen) ->
  $(selector).dialog
    title: title
    autoOpen: false
    closeOnEscape: true
    modal: true
    width: 500
    dialogClass: dialogMainClass
    resizable: false
    open: () ->
      fixCloseButton(this)
      if cbOpen
        cbOpen()
  return

buildDasboardView = ->
  cleanFormData()
  titleDialogUpdateAchievement = $(dialogUpdateOpenerSelector).children()[0].textContent
  buildDialog(dialogUpdateAchievementId, titleDialogUpdateAchievement)

  titleDialoNewAchievement = $(buttonDialogDashboardNewAchievementSelector).text()
  buildDialog(dialogDashboardNewAchievementSelector, titleDialoNewAchievement, () -> (
    cleanFormData()
  ))

  titleDialogSendStudentRequest = $(buttonDialogDashboardSendRequestSelector).text()
  buildDialog(dialogSendStudentRequestSelector, titleDialogSendStudentRequest)

  $(buttonDialogDashboardNewAchievementSelector).click ->
    $(dialogDashboardNewAchievementSelector).dialog 'open'
    return

  $(buttonDialogDashboardSendRequestSelector).click ->
    $(dialogSendStudentRequestSelector).dialog 'open'
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

  $(clientsSearchFormInputSelector).keyup((e)->
    if e.keyCode == 13
      value = e.target.value
      $(listDashboardClientsWrapperSelector).html('loading...')
      $.get "/tutor/dashboard/get_clients?search=#{value}", (res) ->
        $(listDashboardClientsWrapperSelector).html(res)
        $wrapper = $(listDashboardClientsWrapperSelector)
        $wrapper.infinitePages
          debug: true
          buffer: 300
          context: listDashboardClientsWrapperSelector
        $(listDashboardClientsWrapperSelector).find(".pagination").hide()
        addEventHadlerForTutorSendRequest(buttonDashboardSendRequestSelector)
        return
    return
  )

  #Load initial events
  addEventHadlerForUserReport(openReportButtonSelector)
  addEventHadlerForTutorEditAchievement(dialogUpdateOpenerSelector, dialogUpdateAchievementId)
  addEventHadlerForTutorSendRequest(buttonDashboardSendRequestSelector)

  $(formId).find(imageContentId).on "content_media_appended", (e, imageLinkElem) ->
    configRemoveItems(imageLinkElem)
    return

isDashboardPage = ->
    $(dashboardPage).length > 0

loadPage = ->
  if isDashboardPage()
    buildDasboardView()
  return

$(document).on "ready page:load", loadPage
