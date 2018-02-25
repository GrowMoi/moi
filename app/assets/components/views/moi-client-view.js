Polymer({
  is: 'moi-client-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior],
  ready: function() {
    var that;
    var studentsApi = '/tutor/dashboard/students';
    var statisticsApi = '/tutor/client/get_client_statistics';
    var params = this.getCurrentUrlParams();
    this.activityPath = '/tutor/analysis/';
    this.activityHref = '';
    this.userId = null;
    this.clientTreeSrc = '';
    this.loading = true;
    this.data = {};
    studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    that = this;
    if (params && params.client_id) {
      that.userId = params.client_id;
      statisticsAjax = $.ajax({
        url: statisticsApi,
        type: 'GET',
        data: {
          client_id: that.userId
        }
      });
      that.getClientStatistics(studentsAjax, statisticsAjax);
    } else {
      that.getStudents(studentsAjax);
    }
  },
  onStudentSelected: function(e, val) {
    this.userId = val;
    this.loading = true;
    that = this;
    statisticsAjax = $.ajax({
      url: '/tutor/client/get_client_statistics',
      type: 'GET',
      data: {
        client_id: that.userId
      }
    });
    that = this;
    $.when(statisticsAjax).then(function(res) {
      that.data = res.data;
      that.data.client = res.meta.client;
      that.activityHref = that.activityPath + that.userId;
      var url = window.location.href.split('?')[0];
      window.history.pushState('data', '', url + '?client_id=' + that.userId);
      that.loading = false;
    });
  },
  onSelectItemsLoaded: function(e, elem) {
    var params = this.getCurrentUrlParams();
    if (params && params.client_id) {
      $(elem).find('select').val(params.client_id);
    }
  },
  getStudents: function(studentsAjax) {
    that = this;
    $.when(studentsAjax).then(function(res) {
      if (res.data) {
        that.students = that.formatStudentData(res.data);
      }
      that.loading = false;
    });
  },
  getClientStatistics: function(studentsAjax, statisticsAjax) {
    that = this;
    $.when(studentsAjax, statisticsAjax).then(function(res1, res2) {
      if (res1[0].data) {
        that.students = that.formatStudentData(res1[0].data);
      }
      if (res2[0].data) {
        that.data = res2[0].data;
        that.data.client = res2[0].meta.client;
      }
      that.loading = false;
    });
  }


});
