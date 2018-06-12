Polymer({
  is: 'moi-tutor-notifications-card-content',
  behaviors: [TranslateBehavior, AssetBehavior],
  properties: {
    tutorId: String,
  },
  ready: function () {
    this.startPusherClient();
    this.notifications = [];
    var notificationsApi = '/tutor/dashboard/notifications';
    this.rowImage = this.assetPath('check_green.png');
    this.titleMapping = {
      'client_got_item': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_item'),
      'client_test_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_test_completed'),
      'client_message_opened': this.t('views.tutor.dashboard.card_tutor_notifications.client_message_opened'),
      'client_recommended_contents_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_recommended_contents_completed'),
      'client_got_diploma': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_diploma')
    }
    this.loading = true;
    $.ajax({
      url: notificationsApi,
      type: 'GET',
      success: this.onGetNotificationsApiSuccess.bind(this)
      //error:  this.onGetNotificationsApiError.bind(this)
    });
  },
  onNotificationReceived: function(message) {

  },
  startPusherClient: function() {
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
  onGetNotificationsApiSuccess: function(res) {
    this.loading = false;
    this.notifications = res.data || [];
    this.formatNotifications(this.notifications);
  },
  formatNotifications: function(data) {
    for(var i = 0; i < data.length; i ++) {
      this.addTitleToNotification(data[i]);
    }
  },
  addTitleToNotification: function(notification) {
    notification.title = this.titleMapping[notification.data_type] || '';
  }
});
