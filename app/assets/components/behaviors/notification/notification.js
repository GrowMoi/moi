var NotificationBehavior = NotificationBehavior || {};

var pusherClient = null;

NotificationBehavior.pusherClient = pusherClient;

NotificationBehavior.createNewPusherClient = function (pusherAppKey, onConnected) {
  pusherClient = new Pusher(pusherAppKey, {
    encrypted: true,
    cluster: 'us2'
  });
  NotificationBehavior.pusherClient = pusherClient;
  pusherClient.connection.bind('connected', onConnected);
}

NotificationBehavior.pusherClient = pusherClient;

NotificationBehavior.isActivePusherClient = function () {
  var isActive = NotificationBehavior.pusherClient ? true : false;
  return isActive;
};

NotificationBehavior.listenChannel = function(channelName, eventName, callback){
  if (NotificationBehavior.pusherClient) {
    var channel = NotificationBehavior.pusherClient.subscribe(channelName);
    channel.bind(eventName, callback);
  } else {
    console.error('There is not Pusher client active.');
  }
};

NotificationBehavior.notificationCounter = null;

NotificationBehavior.getNotifications = function(cb) {
  if (NotificationBehavior.notificationCounter === null) {
    var notificationsApi = '/tutor/notifications/info';
    $.ajax({
      url: notificationsApi,
      type: 'GET',
      success: function(res) {
        var newNotifications = res.data.filter(function(notification) {
          return !notification.opened;
        }) || [];
        var counter = newNotifications.length;
        cb(counter);
      },
      error: function() {
        cb(0);
      }
    });
  } else {
    cb(NotificationBehavior.notificationCounter);
  }
};

NotificationBehavior.pusherEvents = [
  'client_test_completed',
  'client_message_open',
  'client_got_item',
  'client_recommended_contents_completed'
];

NotificationBehavior.startPusherForTutorAccount = function(tutorId, onNotificationReceived) {
  if (!NotificationBehavior.pusherClient) {
    NotificationBehavior.createNewPusherClient(ENV.pusherAppKey, function() {
      console.log('Pusher: connection successful!');
      NotificationBehavior.startPusherNotificationChannel(tutorId, onNotificationReceived);
    });
  } else {
    NotificationBehavior.startPusherNotificationChannel(tutorId, onNotificationReceived);
  }
}

NotificationBehavior.startPusherNotificationChannel = function(tutorId, onNotificationReceived) {
  var channel = 'tutornotifications.' + tutorId;
  NotificationBehavior.pusherEvents.forEach(function(eventName) {
    NotificationBehavior.listenChannel(
      channel,
      eventName,
      onNotificationReceived
    );
  });
};
