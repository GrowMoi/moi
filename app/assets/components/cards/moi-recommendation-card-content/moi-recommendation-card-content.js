Polymer({
  is: 'moi-recommendation-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    achievementsApi: String,
    achievementsPlaceholder: String,
    contentsApi: String,
    contentsPlaceholder: String,
    createRecomendationsApi: String,
    studentsApi: String,
    authToken: String
  },
  ready: function() {
    var achievementsAjax, contentsAjax, studentsAjax, that;
    this.achievements = [];
    this.contents = [];
    this.btnText = I18n.t('views.tutor.common.send');
    this.btnSendText = this.btnText;
    this.btnSendingText = I18n.t('views.submitting');
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
      url: that.achievementsApi,
      type: 'GET'
    });
    contentsAjax = $.ajax({
      url: that.contentsApi,
      type: 'GET'
    });
    studentsAjax = $.ajax({
      url: that.studentsApi,
      type: 'GET'
    });
    $.when(achievementsAjax, contentsAjax, studentsAjax).then(function(res1, res2, res3) {
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
  onItemSelected: function(e, val) {
    this.apiParams.tutor_achievement = val;
    this.enableSendButton();
  },
  onChoosenItemSelected: function(e, val) {
    this.apiParams.content_tutor_recommendations.push(val);
    this.enableSendButton();
  },
  onChoosenItemDeselected: function(e, val) {
    var index;
    index = this.apiParams.content_tutor_recommendations.indexOf(val);
    if (index !== -1) {
      this.apiParams.content_tutor_recommendations.splice(index, 1);
    }
    this.enableSendButton();
  },
  sendRecommendation: function() {
    var that;
    that = this;
    $(that.$.btnsend).addClass('disabled');
    that.btnSendText = that.btnSendingText;
    $.ajax({
      url: that.createRecomendationsApi,
      type: 'POST',
      data: {
        tutor_recommendation: this.apiParams
      }
    });
  },
  formatData: function(items, textParamName) {
    return $.map(items, function(item) {
      return {
        id: item.id,
        text: item[textParamName]
      };
    });
  },
  enableSendButton: function() {
    if ((this.apiParams.tutor_achievement === '') || (this.apiParams.content_tutor_recommendations.length === 0) || (this.apiParams.students.length === 0)) {
      return $(this.$.btnsend).addClass('disabled');
    } else {
      return $(this.$.btnsend).removeClass('disabled');
    }
  },
  openDialog: function() {
    var dialog;
    dialog = this.$.dialog;
    if ($(dialog).is(':hidden')) {
      this.$.form.reset();
      $(this.$.fileselect).val('');
      $(this.$.imagecontent).children().remove();
      return $(dialog).show();
    }
  },
  onStudentSelected: function(e, val) {
    this.apiParams.students = [val];
    return this.enableSendButton();
  }
});
