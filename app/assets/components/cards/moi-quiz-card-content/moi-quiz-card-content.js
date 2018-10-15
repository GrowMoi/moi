Polymer({
  is: 'moi-quiz-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function() {
    this.init();
  },
  reload: function() {
    this.init();
  },
  init: function () {
    var levelsAjax, studentsAjax;
    this.levels = [];
    this.students = [];
    this.questions = [];
    this.contents = [];
    this.loading = true;
    this.btnText = I18n.t('views.tutor.common.send');
    this.btnSendText = this.btnText;
    this.btnSendingText = I18n.t('views.submitting');
    this.btnLevelSendText = this.btnText;
    this.levelsApi = '/tutor/dashboard/get_level_quizzes';
    this.studentsApi = '/tutor/dashboard/students';
    this.questionsApi = '/tutor/dashboard/get_questions';
    this.quizzesApi = '/tutor/dashboard/create_quiz';
    this.contentsApi = '/tutor/dashboard/get_contents';
    this.createlevelApi = '/tutor/dashboard/level';
    this.checkboxStatus = false;
    this.newTutorLevelParams = {
      name: '',
      content_ids: [],
      description: ''
    };

    $(this.$.btnsend).addClass('disabled');
    this.apiParams = {
      level_quiz_id: '',
      client_id: '',
      send_to_all: false
    };
    levelsAjax = $.ajax({
      url: this.levelsApi,
      type: 'GET'
    });
    studentsAjax = $.ajax({
      url: this.studentsApi,
      type: 'GET'
    });
    $.when(levelsAjax, studentsAjax).then(function (res1, res2) {
      if (res1[0].data) {
        this.levels = this.formatData(res1[0].data);
      }
      if (res2[0].data) {
        this.students = this.formatStudentData(res2[0].data);
      }
      this.loading = false;
    }.bind(this));

    $.ajax({
      url: this.contentsApi,
      type: 'GET',
      success: function (res) {
        if (res.data) {
          this.contents = this.formatContentsData(res.data, 'title');
        }
      }.bind(this)
    });
  },
  onLevelSelected: function (e, val) {
    var content_ids, item;
    item = this.levels.find(function (item) {
      return item.id === parseInt(val);
    });
    this.apiParams.level_quiz_id = val;
    content_ids = item.content_ids;
    this.enableSendButton();
    $.ajax({
      url: this.questionsApi,
      type: 'GET',
      data: {
        content_ids: content_ids
      },
      success: function (res) {
        this.questions = res.data;
      }.bind(this)
    });
  },
  onStudentSelected: function (e, val) {
    this.apiParams.client_id = val;
    this.enableSendButton();
  },
  formatData: function (items) {
    return $.map(items, function (item) {
      return {
        id: item.id,
        text: item.name,
        content_ids: item.content_ids
      };
    });
  },
  sendQuiz: function () {
    $(this.$.btnsend).addClass('disabled');
    this.btnSendText = this.btnSendingText;
    $.ajax({
      url: this.quizzesApi,
      type: 'POST',
      data: {
        quiz: this.apiParams
      }
    });
  },
  enableSendButton: function () {
    if (((this.apiParams.level_quiz_id === '') || (this.apiParams.client_id === '') &&
        !this.apiParams.send_to_all)) {

      return $(this.$.btnsend).addClass('disabled');
    } else {
      return $(this.$.btnsend).removeClass('disabled');
    }
  },
  bindOptions: function() {
    this.registerLocalApi();
  },
  registerLocalApi: function() {
    if (this.options && this.options.onRegisterApi) {
      var api = this.createPublicApi();
      this.options.onRegisterApi(api);
    }
  },
  createPublicApi: function() {
    return {
      reload: this.reload.bind(this)
    };
  },
  onCheckboxChange: function() {
    this.checkboxStatus = !this.checkboxStatus;
    this.apiParams.send_to_all = this.checkboxStatus;
    this.enableSendButton();
    this.disableSelector(this.checkboxStatus);
  },
  disableSelector: function (disable) {
    if (disable) {
      $(this.$$('#studentSelector')).addClass('disabled');
    } else {
      $(this.$$('#studentSelector')).removeClass('disabled');
    }
  },
  openNewLevelDialog: function () {
    this.resetFormData();
    $(this.$.dialogNewQuiz).show();
  },
  onSubmitNewTutorLevel: function (event) {
    event.preventDefault();
    this.btnLevelSendText = this.btnSendingText;
    $(this.$.btnLevelSend).addClass('disabled');
    $.ajax({
      url: this.createlevelApi,
      type: 'POST',
      data: {
        level_quiz: this.newTutorLevelParams
      },
      success: function (res) {
        this.btnLevelSendText = this.btnText;
        $(this.$.btnLevelSend).removeClass('disabled');
        if (res.data) {
          $(this.$['dialogNewQuiz']).hide();
          var newLevelasArray = this.formatData([res.data]);
          this.unshift('levels', newLevelasArray[0]);
        }
        this.toastMessage = this.t('views.tutor.dashboard.card_quizzes.create_level_success');

        this.$.toastMessage.show();
      }.bind(this),
      error: function () {
        this.btnLevelSendText = this.btnText;
        $(this.$.btnLevelSend).removeClass('disabled');
        this.toastMessage = this.t('views.tutor.dashboard.card_quizzes.create_level_error');
        this.$.toastMessage.show();
      }.bind(this),
    });
  },
  formatContentsData: function (items, textParamName) {
    return $.map(items, function (item) {
      return {
        id: item.id,
        text: item[textParamName]
      };
    });
  },
  onChoosenContentSelected: function (e, val) {
    this.newTutorLevelParams.content_ids.push(val);
  },
  onChoosenContentDeselected: function (e, val) {
    var index = this.newTutorLevelParams.content_ids.indexOf(val);
    if (index !== -1) {
      this.newTutorLevelParams.content_ids.splice(index, 1);
    }
  },
  resetFormData: function() {
    this.$.quizForm.reset();
    this.newTutorLevelParams = {
      name: '',
      content_ids: [],
      description: ''
    };
    this.choosenRestarted = false;
    this.async(function() {
      this.choosenRestarted = true;
    }.bind(this));
  }
});
