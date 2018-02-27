Polymer({
  is: 'moi-recommendation-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String
  },
  ready: function () {
    var achievementsAjax, contentsAjax, studentsAjax, that;
    var achievementsApi = '/tutor/dashboard/achievements';
    var studentsApi = '/tutor/dashboard/students';
    var contentsApi = '/tutor/dashboard/get_contents';
    this.achievements = [];
    this.contents = [];
    this.btnText = this.t('views.tutor.dashboard.card_recommendations.btn_send');
    this.btnSendText = this.btnText;
    this.btnSendingText = this.t('views.submitting');
    this.achievementsPlaceholder = this.t('views.tutor.dashboard.card_recommendations.achievements_placeholder');
    this.contentsPlaceholder = this.t('views.tutor.dashboard.card_recommendations.contents_placeholder');;
    this.createRecomendationsApi = '/tutor/recommendations';
    $(this.$.btnsend).addClass('disabled');
    this.apiParams = {
      tutor_achievement: '',
      content_tutor_recommendations: [],
      students: []
    };
    this.enableSendButton();
    this.loading = true;
    that = this;
    achievementsAjax = $.ajax({
      url: achievementsApi,
      type: 'GET'
    });
    contentsAjax = $.ajax({
      url: contentsApi,
      type: 'GET'
    });
    studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    $.when(achievementsAjax, contentsAjax, studentsAjax).then(function (res1, res2, res3) {
      if (res1[0].data) {
        that.achievements = that.formatData(res1[0].data, 'name');
      }
      if (res2[0].data) {
        that.contents = that.formatData(res2[0].data, 'title');
      }
      if (res3[0].data) {
        that.students = that.formatStudentData(res3[0].data);
      }
      that.loading = false;
    });
  },
  onItemSelected: function (e, val) {
    this.apiParams.tutor_achievement = val;
    this.enableSendButton();
  },
  onChoosenItemSelected: function (e, val) {
    this.apiParams.content_tutor_recommendations.push(val);
    this.enableSendButton();
  },
  onChoosenItemDeselected: function (e, val) {
    var index = this.apiParams.content_tutor_recommendations.indexOf(val);
    if (index !== -1) {
      this.apiParams.content_tutor_recommendations.splice(index, 1);
    }
    this.enableSendButton();
  },
  sendRecommendation: function () {
    var that = this;
    $(that.$.btnsend).addClass('disabled');
    that.btnSendText = that.btnSendingText;
    $.ajax({
      url: that.createRecomendationsApi,
      type: 'POST',
      data: {
        tutor_recommendation: that.apiParams
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
  enableSendButton: function () {
    if ((this.apiParams.tutor_achievement === '') || (this.apiParams.content_tutor_recommendations.length === 0) || (this.apiParams.students.length === 0)) {
      return $(this.$.btnsend).addClass('disabled');
    } else {
      return $(this.$.btnsend).removeClass('disabled');
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
    return this.enableSendButton();
  }
});
