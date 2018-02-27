Polymer({
  is: 'moi-send-notifications-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    currentTime: {
      type: Number,
      default: Date.now()
    },
    notificationTitle: {
      type: String,
      default: '',
      observer: 'enterTitle'
    }
  },
  ready: function () {
    var that = this;
    that.loading = true;
    that.btnsendId = '#btnsend';
    that.formId = '#form';
    that.studentsApi = '/tutor/dashboard/students';
    that.sendNotificationApi = '/tutor/dashboard/send_notification';
    that.userIdSelect = '';
    that.title = '';

    var studentsAjax = $.ajax({
      url: that.studentsApi,
      type: 'GET'
    });
    return $.when(studentsAjax).then(function (res1) {
      var currentTime;
      that.loading = false;
      currentTime = Date.now();
      if (res1.data) {
        that.students = that.formatStudentData(res1.data);
      }
      return that.async(function () {
        that.disableBtn(that.btnsendId);
        return that.buildInputFileName(currentTime);
      });
    });
  },
  onSelectFile: function (e, val) {
    var currentTime;
    currentTime = Date.now();
    return this.updateInputFileName(currentTime);
  },
  buildInputFileName: function (currentTime) {
    var paramName;
    paramName = 'notification_medium_attributes';
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
    var btnSend;
    btnSend = Polymer.dom(this.root).querySelector(id);
    return $(btnSend).removeClass('disabled');
  },
  disableBtn: function (id) {
    var btnSend;
    btnSend = Polymer.dom(this.root).querySelector(id);
    return $(btnSend).addClass('disabled');
  },
  enterTitle: function (newVal) {
    this.title = newVal;
    return this.enableSendButton();
  }
});
