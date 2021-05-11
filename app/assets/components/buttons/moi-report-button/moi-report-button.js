Polymer({
  is: 'moi-report-button',
  properties: {
    href: String,
    text: String,
    queryHref: String,
    loadingText: String
  },
  onClick: function(){
    var self;
    this.originalText = this.text;
    this.text = this.loadingText;
    this.button = this.$['report-button'];
    $(this.button).addClass('disabled');
    self = this;
    $.ajax({
      url: this.href,
      type: 'GET',
      success: function(res) {
        AnalyticsBehavior.track('send', 'event', 'Generar reporte en formato para excel', 'Click');
        self.processing.call(self, res);
      }
    });
  },
  processing: function(res){
    var report = res.report;
    this.reportId = report.id;
    this.queryReportStatus.call(this);
  },
  queryReportStatus: function(){
    var self = this;
    setTimeout(function(){
      $.ajax({
        url: self.queryHref + "/" + self.reportId,
        type: 'GET',
        success: function(res) {
          var report = res.report;
          if (report.status == 'processed') {
            self.text = self.originalText;
            $(self.button).removeClass("disabled");
            window.location = "/" + report.uri;
          } else {
            self.queryReportStatus.call(self);
          }
        }
      });
    }, 2000);
  }
});
