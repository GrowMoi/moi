Polymer({
  is: 'moi-dashboard-view',
  behaviors: [TranslateBehavior, NotificationBehavior],
  properties: {
    authToken: String
  },
  ready: function() {
    this.userCardApi = null;
    this.studentCardApi = null;
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));

    this.userCardOptions = {
      onRegisterApi: this.onRegisterUserCardApi.bind(this)
    };
    this.studentCardOptions = {
      onRegisterApi: this.onRegisterStudentCardApi.bind(this)
    };
  },
  onRegisterUserCardApi: function(api) {
    this.userCardApi = api;
    this.userCardApi.onUserRemoved(function(userRemoved) {
      if(this.studentCardApi.addStudent) {
        this.studentCardApi.addStudent(userRemoved);
      }
    }.bind(this));
  },
  onRegisterStudentCardApi: function(api) {
    this.studentCardApi = api;
  }
});
