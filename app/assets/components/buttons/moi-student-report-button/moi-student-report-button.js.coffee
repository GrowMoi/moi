Polymer
  is: 'moi-student-report-button'
  properties:
    studentId: String
    glyphicon: String
    text: String
  ready: ->
    $(@$.btnredirect).addClass 'glyphicon ' + @glyphicon
    return
  redirectToReportPage: (e) ->
    e.stopPropagation()
    origin = window.location.origin
    window.open "#{origin}/tutor/report?user_id=#{@studentId}", '_blank'
    return
