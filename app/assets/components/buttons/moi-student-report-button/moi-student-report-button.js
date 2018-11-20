Polymer({
  is: 'moi-student-report-button',
  properties: {
    studentId: String,
    username: String,
    glyphicon: String,
    text: String
  },
  ready: function() {
    $(this.$.btnredirect).addClass('glyphicon ' + this.glyphicon);
  },
  redirectToReportPage: function(e) {
    var origin;
    e.stopPropagation();
    origin = window.location.origin;
    AnalyticsBehavior.track('send', 'event', 'Generar reporte ' + this.username, 'Click');
    window.open(origin + "/tutor/report?user_id=" + this.studentId, '_blank');
  }
});
