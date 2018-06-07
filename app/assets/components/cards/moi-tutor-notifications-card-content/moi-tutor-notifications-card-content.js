Polymer({
  is: 'moi-tutor-notifications-card-content',
  ready: function () {
    if (!NotificationBehavior.pusherClient) {
      NotificationBehavior.createNewPusherClient(ENV.pusherAppKey, function() {
        console.log('Pusher: connection successful!');
      });
    }
  }
});
