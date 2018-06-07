var AssetBehavior = AssetBehavior || {};
AssetBehavior.assetPath = function(logicalPath) {
  return window.asset_path(logicalPath);
};

var NotificationBehavior = NotificationBehavior || {};

var pusherClient = null;

NotificationBehavior.pusherClient = pusherClient;

NotificationBehavior.createNewPusherClient = function (pusherAppKey, onConnected) {
  pusherClient = new Pusher(pusherAppKey, {
    encrypted: true,
    cluster: 'us2'
  });

  pusherClient.connection.bind('connected', onConnected);
}

NotificationBehavior.pusherClient = pusherClient;

NotificationBehavior.isActivePusherClient = function () {
  var isActive = NotificationBehavior.pusherClient ? true : false;
  return isActive;
};

