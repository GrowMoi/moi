Polymer({
  is: 'moi-student-card-content',
  behaviors: [TranslateBehavior, AssetBehavior],
  ready: function () {
    debugger
    var _this = this;
    var studentsApi = '/tutor/dashboard/students';
    _this.students = [];
    _this.studentsSelected = [];
    _this.rowImgActive = _this.assetPath('client_avatar_green.png');
    _this.rowImgInactive = _this.assetPath('client_avatar_inactive.png');
    _this.rowImgCheck = _this.assetPath('check_green.png');
    _this.downloadBtnFilename = 'reporte_' + Date.now() + '.xls';
    $(_this.$.btnSelectiveDownload).addClass('disabled');
    _this.loading = true;
    $.ajax({
      url: studentsApi,
      type: 'GET',
      success: function (res) {
        _this.loading = false;
        _this.students = res.data;
      }
    });
  },
  onRowSelectedHandler: function (e, data) {
    var index = this.studentsSelected.indexOf(data);
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
  },
  openDialog: function() {
    this.$.toast2.show();
  }
});
