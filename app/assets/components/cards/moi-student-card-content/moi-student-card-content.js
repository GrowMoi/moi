Polymer({
  is: 'moi-student-card-content',
  behaviors: [TranslateBehavior, AssetBehavior],
  ready: function() {
    var that;
    var studentsApi = '/tutor/dashboard/students';
    this.students = [];
    this.studentsSelected = [];
    this.rowImgActive = this.assetPath('client_avatar_green.png');
    this.rowImgInactive = this.assetPath('client_avatar_inactive.png');
    this.rowImgCheck = this.assetPath('check_green.png');
    this.downloadBtnFilename = 'reporte_' + Date.now() + '.xls';
    $(this.$.btnSelectiveDownload).addClass('disabled');
    this.loading = true;
    that = this;
    $.ajax({
      url: studentsApi,
      type: 'GET',
      success: function(res) {
        that.loading = false;
        that.students = res.data;
      }
    });
  },
  onRowSelectedHandler: function(e, data) {
    var index;
    index = this.studentsSelected.indexOf(data);
    if (index !== -1) {
      this.splice('studentsSelected', index, 1);
    } else {
      this.push('studentsSelected', data);
    }
    if (this.studentsSelected.length > 0) {
      $(this.$.btnSelectiveDownload).removeClass('disabled');
    } else {
      $(this.$.btnSelectiveDownload).addClass('disabled');
    }
  }
});
