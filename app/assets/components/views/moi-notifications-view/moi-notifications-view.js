Polymer({
  is: 'moi-notifications-view',
  behaviors: [TranslateBehavior, NotificationBehavior],
  properties: {
    tutorId: String,
  },
  ready: function() {
    var path = location.pathname;
    AnalyticsBehavior.track('set', 'page', path);
    AnalyticsBehavior.track('send', 'pageview');

    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));

    this.notificationCardOptions = {
      onRegisterApi: this.onRegisterNotificationCardApi.bind(this)
    };

  },
  onRegisterNotificationCardApi: function(api) {
    this.notificationCardApi = api;
    this.notificationCardApi.onNotificationOpen(function(item) {
      AnalyticsBehavior.track('send', 'event', 'Abrir notificación', 'Click');
      if (this.notificationCounter > 0) {
        this.notificationCounter--;
      }
    }.bind(this));
    this.notificationCardApi.onNotificationRemoved(function(item) {
      AnalyticsBehavior.track('send', 'event', 'Remover notificación', 'Click');
      if (!item.opened) {
        this.notificationCounter--;
      }
    }.bind(this));
    this.notificationCardApi.onNotificationReceived(function(item) {
      AnalyticsBehavior.track('send', 'event', 'Recibir nueva notificación', 'Click');
      this.notificationCounter++;
      NotificationBehavior.applyBadgetEffect(this.$.moiBadge);
    }.bind(this));
  }
});
