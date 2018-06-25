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
}

