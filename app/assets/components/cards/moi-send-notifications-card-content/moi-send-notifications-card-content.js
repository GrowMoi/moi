Polymer({
  is: 'moi-send-notifications-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    currentTime: {
      type: Number,
      value: Date.now()
    },
    notificationTitle: {
      type: String,
      value: '',
      observer: 'enterTitle'
    }
  },
  ready: function () {
    var _this = this;
    _this.loading = true;
    _this.btnsendId = '#btnsend';
    _this.formId = '#form';
    _this.studentsApi = '/tutor/dashboard/students';
    _this.sendNotificationApi = '/tutor/dashboard/send_notification';
    _this.userIdSelect = '';
    _this.title = '';

    var studentsAjax = $.ajax({
      url: _this.studentsApi,
      type: 'GET'
    });
    return $.when(studentsAjax).then(function (res1) {
      var currentTime;
      _this.loading = false;
      currentTime = Date.now();
      if (res1.data) {
        _this.students = _this.formatStudentData(res1.data);
      }
      return _this.async(function () {
        _this.disableBtn(_this.btnsendId);
        return _this.buildInputFileName(currentTime);
      });
    });
  },
  onSelectFile: function (e, val) {
    var currentTime = Date.now();
    return this.updateInputFileName(currentTime);
  },
  buildInputFileName: function (currentTime) {
    var paramName = 'notification_medium_attributes';
    this.mediaInputName = "notification[" + paramName + "][" + currentTime + "][media]";
    this.cacheName = "notification[" + paramName + "][" + currentTime + "][media_cache]";
  },
  updateInputFileName: function (currentTime) {
    this.buildInputFileName(currentTime);
  },
  enableSendButton: function () {
    if (this.title.length > 0 && this.userIdSelect.length > 0) {
      return this.enableBtn(this.btnsendId);
    } else {
      return this.disableBtn(this.btnsendId);
    }
  },
  onStudentSelected: function (e, val) {
    this.userIdSelect = val;
    return this.enableSendButton();
  },
  enableBtn: function (id) {
    var btnSend = this.$$(id);
    return $(btnSend).removeClass('disabled');
  },
  disableBtn: function (id) {
    var btnSend = this.$$(id);
    return $(btnSend).addClass('disabled');
  },
  enterTitle: function (newVal) {
    this.title = newVal;
    return this.enableSendButton();
  }
});
