formId = '#form-new-achievement'
imageContentId = '#content-media-name-on-form'
inputFileId = '#achievement-file-select'
buttonSendForm = '#button_submit_recommendation'

fixCloseButton = (elem) ->
  $(elem).closest('.ui-dialog')
         .find('.ui-dialog-titlebar-close')
         .removeClass('ui-dialog-titlebar-close')
         .html '<span class=\'ui-button-icon-primary ui-icon ui-icon-closethick\'></span>'

applyChosen = ->
  $("#content_recommendations").chosen allow_single_deselect: true, disable_search_threshold: 10

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
  dialogContentId = '#dialog-new-achievement'
  dialogMainClass = 'dialog-new-achievement'
  dialogOpenerId = '#button-dialog-new-achievement'
  cleanFormData()
  $(dialogContentId).dialog
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

configButtonSend = ->
  $(buttonSendForm).addClass 'disabled'
  $('#content_recommendations').change ->
    updateButtonStatus(buttonSendForm)
  $('#achievement_recommendations').change ->
    updateButtonStatus(buttonSendForm)

updateButtonStatus = (buttonId) ->
  value1 = $('#content_recommendations').val()
  value2 = $('#achievement_recommendations').val()
  if (value1 && value1.length > 0) && value2.length > 0
    $(buttonId).removeClass 'disabled'
  else
    $(buttonId).addClass 'disabled'
  return

$(document).on "ready page:load", applyChosen
$(document).on "ready page:load", buildDialog
$(document).on "ready page:load", configButtonSend
