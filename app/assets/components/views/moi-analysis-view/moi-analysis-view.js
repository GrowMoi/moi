Polymer({
  is: 'moi-analysis-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior],
  ready: function () {
    var that = this;
    var studentsApi = '/tutor/dashboard/students';
    var studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    that.students = [];
    that.loading = true;
    that.userIdSelected = null;
    that.hasContentReadingTime = false;
    that.analysisApi = '/tutor/analysis/get_user_analysis';
    that.data = {};
    var params = that.getCurrentUrlParams();
    if (params && params.client_id) {
      that.userIdSelected = params.client_id;
      var analysisAjax = that.buildAnalysisAjax(that.userIdSelected);
      that.getClientAnalysis(studentsAjax, analysisAjax).done(function () {
        that.loading = false;
      });
    } else {
      that.getStudents(studentsAjax).done(function () {
        that.loading = false;
      });
    }
  },
  getStudents: function (studentsAjax) {
    var that = this;
    return $.when(studentsAjax).then(function (res) {
      if (res.data) {
        that.students = that.formatStudentData(res.data);
      }
    });
  },
  onStudentSelected: function (e, val) {
    var that = this;
    that.userIdSelected = val;
    that.loading = true;
    var analysisAjax = that.buildAnalysisAjax(that.userIdSelected);
    $.when(analysisAjax).then(function (res) {
      that.prepareAndFormatAnalysisData(res);
      that.addParamToUrl('analysis', 'client_id', that.userIdSelected);
    }).done(function () {
      that.loading = false;
    });
  },
  onSelectItemsLoaded: function (e, elem) {
    var that = this;
    var params = that.getCurrentUrlParams();
    if (params && params.client_id) {
      $(elem).find('select').val(params.client_id);
    }
  },
  getClientAnalysis: function (studentsAjax, analysisAjax) {
    var that = this;
    return $.when(studentsAjax, analysisAjax).then(function (res1, res2) {
      if (res1[0].data) {
        that.students = that.formatStudentData(res1[0].data);
      }
      if (res2[0].data) {
        that.prepareAndFormatAnalysisData(res2[0]);
      }
    });
  },
  prepareAndFormatAnalysisData: function (res) {
    var that = this;
    that.data = res.data;
    that.data.username = res.meta.client.username;
    var contentReadings = that.data.statistics.content_readings_by_branch.value;
    var timeItems = that.convertObjectToArrayItems(contentReadings);
    that.data.statistics.content_readings_by_branch.value = timeItems;
    debugger
    that.hasContentReadingTime = (that.data.grouped_reading_time &&
      that.data.grouped_reading_time.length > 0);
  },
  buildAnalysisAjax: function (userIdSelected) {
    var that = this;
    return $.ajax({
      url: that.analysisApi,
      type: 'GET',
      data: {
        client_id: userIdSelected
      }
    });
  }

});
