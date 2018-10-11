Polymer({
  is: 'moi-recommendation-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    type: {
      type: String,
      default: 'card'
    },
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function () {
    this.init();
  },
  reload: function () {
    this.init();
  },
  init: function () {
    var achievementsAjax, studentsAjax;
    var achievementsApi = '/tutor/dashboard/achievements';
    var studentsApi = '/tutor/dashboard/students';
    this.contentsApi = '/tutor/dashboard/get_contents';
    this.isCardType = this.type == 'card';
    this.achievements = [];
    this.contents = [];
    this.btnText = this.t('views.tutor.dashboard.card_recommendations.btn_send');
    this.btnSendText = this.btnText;
    this.btnSendingText = this.t('views.submitting');
    this.createRecomendationsApi = '/tutor/recommendations';
    this.loadingContents = false;
    this.previousStudentIds = null;
    this.apiParams = {
      tutor_achievement: '',
      content_tutor_recommendations: [],
      students: []
    };
    this.partialCardRecommendationOptions = {
      onRegisterApi: this.onRegisterPartialCardRecommendationOptions.bind(this)
    };
    this.loading = true;
    this.disableSendButton = true;
    achievementsAjax = $.ajax({
      url: achievementsApi,
      type: 'GET'
    });

    studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    $.when(achievementsAjax, studentsAjax).then(function (res1, res2) {
      if (res1[0].data) {
        this.achievements = this.formatData(res1[0].data, 'name');
      }
      if (res2[0].data) {
        this.students = this.formatStudentData(res2[0].data);
      }
      this.loading = false;
      this.async(function () {
        this.disableContentSelector();
      }.bind(this));

    }.bind(this));
  },
  bindOptions: function () {
    this.registerLocalApi();
  },
  registerLocalApi: function () {
    if (this.options && this.options.onRegisterApi) {
      var api = this.createPublicApi();
      this.options.onRegisterApi(api);
    }
  },
  createPublicApi: function () {
    return {
      reload: this.reload.bind(this)
    };
  },
  onAchievementSelected: function (e, val) {
    this.apiParams.tutor_achievement = val;
    this.updateSendButtonState();
  },
  onChoosenContentSelected: function (e, val) {
    this.apiParams.content_tutor_recommendations.push(val);
    this.updateSendButtonState();
  },
  onChoosenContentDeselected: function (e, val) {
    var index = this.apiParams.content_tutor_recommendations.indexOf(val);
    if (index !== -1) {
      this.apiParams.content_tutor_recommendations.splice(index, 1);
    }
    this.updateSendButtonState();
  },
  sendRecommendation: function () {
    this.disableSendButton = true;
    this.btnSendText = this.btnSendingText;
    $.ajax({
      url: this.createRecomendationsApi,
      type: 'POST',
      data: {
        tutor_recommendation: this.apiParams
      }
    });
  },
  formatData: function (items, textParamName) {
    return $.map(items, function (item) {
      return {
        id: item.id,
        text: item[textParamName]
      };
    });
  },
  updateSendButtonState: function () {
    if ((this.apiParams.tutor_achievement === '') ||
      (this.apiParams.content_tutor_recommendations.length === 0) ||
      (this.apiParams.students.length === 0)) {

      this.disableSendButton = true;
    } else {
      this.disableSendButton = false;
    }
  },
  openDialog: function () {
    var dialog = this.$.dialog;
    if ($(dialog).is(':hidden')) {
      this.$.form.reset();
      $(this.$.fileselect).val('');
      $(this.$.imagecontent).children().remove();
      return $(dialog).show();
    }
  },
  onStudentSelected: function (e, val) {
    this.apiParams.students = [val];
    this.disableContentSelector();
    this.loadingContents = true;
    $.ajax({
      url: this.contentsApi,
      type: 'GET',
      data: {
        user_id: val
      },
      success: function (res) {
        if (res.data) {
          this.loadingContents = false;
          this.contents = this.formatData(res.data, 'title');
          this.enableContentSelector();
          this.updateSendButtonState();
        }
      }.bind(this)
    });
  },
  disableContentSelector: function () {
    if (this.partialCardRecommendationApi && this.partialCardRecommendationApi.disableChoosen) {
      this.partialCardRecommendationApi.disableChoosen(true);
    }
  },
  enableContentSelector: function () {
    if (this.partialCardRecommendationApi && this.partialCardRecommendationApi.disableChoosen) {
      this.partialCardRecommendationApi.disableChoosen(false);
    }
  },
  onRegisterPartialCardRecommendationOptions: function (api) {
    this.partialCardRecommendationApi = api;
    this.partialCardRecommendationApi.onCheckboxChange(function (selected) {
      if (selected) {
        var allStudentIds = this.students.map(function (student) {
          return student.id + '';
        });
        this.previousStudentIds = this.apiParams.students;
        this.apiParams.students = allStudentIds;
        if (this.partialCardRecommendationApi.disableSelector) {
          this.partialCardRecommendationApi.disableSelector(true);
          this.disableContentSelector();
          this.loadingContents = true;
          this.reloadContents(null);
        }
      } else {
        this.apiParams.students = this.previousStudentIds || [];
        if (this.partialCardRecommendationApi.disableSelector) {
          this.partialCardRecommendationApi.disableSelector(false);
          if (this.apiParams.students && this.apiParams.students[0]) {
            this.loadingContents = true;
            this.reloadContents(this.apiParams.students[0]);
          } else {
            this.disableContentSelector();
          }
        }
      }
    }.bind(this));
  },
  reloadContents: function(studentId) {
    var data = {};
    if (studentId) {
      data.user_id = studentId;
    }
    $.ajax({
      url: this.contentsApi,
      type: 'GET',
      data: data,
      success: function (res) {
        if (res.data) {
          this.loadingContents = false;
          this.contents = this.formatData(res.data, 'title');
          this.enableContentSelector();
          this.updateSendButtonState();
        }
      }.bind(this)
    });
  }
});
