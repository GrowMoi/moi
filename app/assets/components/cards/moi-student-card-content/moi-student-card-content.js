Polymer({
  is: 'moi-student-card-content',
  behaviors: [TranslateBehavior, AssetBehavior],
  ready: function () {
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
  cancelRequest: function (ev) {
    var element = ev.target;
    $(element).addClass('disabled');
    $.ajax({
      url: '/tutor/user_tutors/' + ev.model.item.id,
      type: 'DELETE',
      data: {
        id: ev.model.item.id
      },
      success: function (res) {
        var index = this.students.indexOf(ev.model.item);
        if (index !== -1) {
          this.splice('students', index, 1);
        }
        this.toastMessage = res.message;
        this.$['toast-message'].show();
      }.bind(this),
      error: function(res) {
        var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
        this.toastMessage = message;
        this.$['toast-message'].show();
      }.bind(this)
    });
  }
});
