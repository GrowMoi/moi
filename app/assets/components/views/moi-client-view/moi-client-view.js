Polymer({
  is: 'moi-client-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior],
  ready: function () {
    var that = this;
    var studentsApi = '/tutor/dashboard/students';
    that.statisticsApi = '/tutor/client/get_client_statistics';
    var params = that.getCurrentUrlParams();
    that.activityPath = '/tutor/analysis';
    that.activityHref = '';
    that.userIdSelected = null;
    that.clientTreeSrc = '';
    that.loading = true;
    that.data = {};
    var studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    if (params && params.client_id) {
      that.userIdSelected = params.client_id;
      var statisticsAjax = that.buildStatisticsAjax(that.userIdSelected);
      that.getClientStatistics(studentsAjax, statisticsAjax).done(function () {
        that.loading = false;
      });
    } else {
      that.getStudents(studentsAjax).done(function () {
        that.loading = false;
      });
    }
  },
  onStudentSelected: function (e, val) {
    var that = this;
    that.userIdSelected = val;
    that.loading = true;
    var statisticsAjax = that.buildStatisticsAjax(that.userIdSelected);
    $.when(statisticsAjax).then(function (res) {
      that.prepareAndFormatAnalysisData(res);
      that.addParamToUrl('client', 'client_id', that.userIdSelected);
    }).done(function (x) {
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
  getStudents: function (studentsAjax) {
    var that = this;
    return $.when(studentsAjax).then(function (res) {
      if (res.data) {
        that.students = that.formatStudentData(res.data);
      }
    });
  },
  getClientStatistics: function (studentsAjax, statisticsAjax) {
    var that = this;
    return $.when(studentsAjax, statisticsAjax).then(function (res1, res2) {
      if (res1[0].data) {
        that.students = that.formatStudentData(res1[0].data);
      }
      if (res2[0].data) {
        that.prepareAndFormatAnalysisData(res2[0]);
      }
    });
  },
  buildStatisticsAjax: function (userIdSelected) {
    var that = this;
    return $.ajax({
      url: that.statisticsApi,
      type: 'GET',
      data: {
        client_id: userIdSelected
      }
    });
  },
  prepareAndFormatAnalysisData: function (res) {
    var that = this;
    that.data = res.data;
    that.data.client = res.meta.client;
    that.activityHref = that.activityPath + '?client_id=' + that.userIdSelected;
  }

});
