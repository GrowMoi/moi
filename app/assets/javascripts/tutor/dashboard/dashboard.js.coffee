dashboardPage = ".container-dashboard"
formId = '#form-new-achievement'
imageContentId = '#content-media-name-on-form'
inputFileId = '#achievement-file-select'
buttonSendForm = '#button_submit_recommendation'

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

buildDialog = ->
  dialogContentId = '#dialog-dashboard-new-achievement'
  dialogMainClass = 'moi-dialog dialog-red dialog-dashboard-new-achievement'
  dialogOpenerId = '#button-dialog-dashboard-new-achievement'
  cleanFormData()
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
