Polymer({
  is: 'moi-tutor-notifications-card-content',
  properties: {
    tutorId: String,
  },
  ready: function () {
    if (!NotificationBehavior.pusherClient) {
      NotificationBehavior.createNewPusherClient(ENV.pusherAppKey, function() {
        console.log('Pusher: connection successful!');
      });
      var channel = 'tutornotifications.' + this.tutorId;
      NotificationBehavior.listenChannel(
        channel,
        'client-test-completed',
        this.onNotificationReceived
      );
    }
  },
  onNotificationReceived: function(message) {

  }
});
