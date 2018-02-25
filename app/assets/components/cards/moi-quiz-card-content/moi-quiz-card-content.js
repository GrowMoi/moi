Polymer({
  is: 'moi-quiz-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    levelsPlaceholder: String,
    studentsPlaceholder: String,
    levelsApi: String,
    studentsApi: String,
    questionsApi: String,
    quizzesApi: String
  },
  ready: function() {
    var levelsAjax, studentsAjax, that;
    this.levels = [];
    this.students = [];
    this.questions = [];
    this.loading = true;
    this.btnText = I18n.t('views.tutor.common.send');
    this.btnSendText = this.btnText;
    this.btnSendingText = I18n.t('views.submitting');
    $(this.$.btnsend).addClass('disabled');
    this.apiParams = {
      level_quiz_id: '',
      client_id: ''
    };
    that = this;
    levelsAjax = $.ajax({
      url: that.levelsApi,
      type: 'GET'
    });
    studentsAjax = $.ajax({
      url: that.studentsApi,
      type: 'GET'
    });
    $.when(levelsAjax, studentsAjax).then(function(res1, res2) {
      if (res1[0].data) {
        that.levels = that.formatData(res1[0].data);
      }
      if (res2[0].data) {
        that.students = that.formatStudentData(res2[0].data);
      }
      that.loading = false;
    });
  },
  onLevelSelected: function(e, val) {
    var content_ids, item, that;
    item = this.levels.find(function(item) {
      return item.id === parseInt(val);
    });
    this.apiParams.level_quiz_id = val;
    content_ids = item.content_ids;
    this.enableSendButton();
    that = this;
    $.ajax({
      url: that.questionsApi,
      type: 'GET',
      data: {
        content_ids: content_ids
      },
      success: function(res) {
        that.questions = res.data;
      }
    });
  },
  onStudentSelected: function(e, val) {
    this.apiParams.client_id = val;
    this.enableSendButton();
  },
  formatData: function(items) {
    return $.map(items, function(item) {
      return {
        id: item.id,
        text: item.name,
        content_ids: item.content_ids
      };
    });
  },
  sendQuiz: function() {
    var that;
    that = this;
    $(that.$.btnsend).addClass('disabled');
    that.btnSendText = that.btnSendingText;
    $.ajax({
      url: that.quizzesApi,
      type: 'POST',
      data: {
        quiz: that.apiParams
      }
    });
  },
  enableSendButton: function() {
    if ((this.apiParams.level_quiz_id === '') || (this.apiParams.client_id === '')) {
      return $(this.$.btnsend).addClass('disabled');
    } else {
      return $(this.$.btnsend).removeClass('disabled');
    }
  }
});
