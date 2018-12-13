Polymer({
  is: 'moi-recommendations-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior, NotificationBehavior],
  properties: {
    tutorId: String
  },
  ready: function() {
    var path = location.pathname;
    AnalyticsBehavior.track('set', 'page', path);
    AnalyticsBehavior.track('send', 'pageview');

    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));

    NotificationBehavior.startPusherForTutorAccount(this.tutorId, this.onNotificationReceived.bind(this));
  },
  onNotificationReceived: function(notification) {
    this.notificationCounter++;
    NotificationBehavior.applyBadgetEffect(this.$.moiBadge);
  }
});
