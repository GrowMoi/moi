Polymer({
  is: 'moi-tutor-notifications-card-content',
  behaviors: [TranslateBehavior, AssetBehavior, NotificationBehavior, UtilsBehavior],
  properties: {
    tutorId: String,
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function() {
    this.init();
  },
  reload: function() {
    this.init();
  },
  init: function () {
    this.notifications = [];
    var notificationsApi = '/tutor/notifications/info';
    this.rowImage = this.assetPath('bell.svg');
    this.emptyNotifications = true;
    this.titleMapping = {
      'client_test_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_test_completed'),
      'client_message_open': this.t('views.tutor.dashboard.card_tutor_notifications.client_message_open'),
      'client_got_item': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_item'),
      'client_recommended_contents_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_recommended_contents_completed'),
      'client_got_diploma': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_diploma'),
      'client_need_validation_content': this.t('views.tutor.dashboard.card_tutor_notifications.client_need_validation_content'),
    };

    this.actionsMapping = {
      'client_test_completed': this.buildClientTestCompleted.bind(this),
      'client_message_open': this.buildClientMessageOpen.bind(this),
      'client_got_item': this.buildClientGotItem.bind(this),
      'client_recommended_contents_completed': this.buildClientRecommendedContentsCompleted.bind(this),
      'client_need_validation_content': this.buildClientNeedValidateAContent.bind(this)
    };

    this.loading = true;
    this.loadingDialogData = false;
    this.itemToRemove = null;
    this.emitters = {
      onNotificationOpen: null,
      onNotificationReceived: null
    };
    this.notificationSelected = null;
    this.request_answer = "";
    this.resetDialogFlags();
    $.ajax({
      url: notificationsApi,
      type: 'GET',
      success: this.onGetNotificationsApiSuccess.bind(this)
      //error:  this.onGetNotificationsApiError.bind(this)
    });
    NotificationBehavior.startPusherForTutorAccount(this.tutorId, this.onNotificationReceived.bind(this));
  },
  bindOptions: function() {
    this.registerLocalApi();
  },
  registerLocalApi: function() {
    if (this.options && this.options.onRegisterApi) {
      var api = this.createPublicApi();
      this.options.onRegisterApi(api);
    }
  },
  createPublicApi: function() {
    return {
      onNotificationOpen: this.loadEmitterNotificationOpen.bind(this),
      onNotificationRemoved: this.loadEmitterOnNotificationRemoved.bind(this),
      onNotificationReceived: this.loadEmitterOnNotificationReceived.bind(this),
      reload: this.reload.bind(this)
    };
  },
  loadEmitterNotificationOpen: function(callback) {
    this.emitters.onNotificationOpen = callback;
  },
  loadEmitterOnNotificationRemoved: function(callback) {
    this.emitters.onNotificationRemoved = callback;
  },
  loadEmitterOnNotificationReceived: function(callback) {
    this.emitters.onNotificationReceived = callback;
  },
  onNotificationReceived: function(notification) {
    this.addTitleToNotification(notification);
    this.push('notifications', notification);
    if (this.emitters.onNotificationReceived) {
      this.emitters.onNotificationReceived(notification);
    }
  },
  onGetNotificationsApiSuccess: function(res) {
    this.loading = false;
    this.notifications = res.data || [];
    this.emptyNotifications = this.notifications.length === 0;
    this.formatNotifications(this.notifications);
  },
  formatNotifications: function(data) {
    for(var i = 0; i < data.length; i ++) {
      this.addTitleToNotification(data[i]);
    }
  },
  addTitleToNotification: function(notification) {
    notification.title = this.titleMapping[notification.data_type] || '';
  },
  openDialogDetails: function(ev) {
    this.loadingDialogData = true;
    this.notificationData = {};
    this.resetDialogFlags();
    var model = ev.model;
    var notificationSelected = model.item;
    this.notificationSelected = notificationSelected;
    $(this.$['dialog-notification-info']).show();
    $.ajax({
      url: '/tutor/notifications/' + notificationSelected.id + '/details',
      type: 'GET',
      success: function(res) {
        this.loadingDialogData = false;
        model.set('item.opened', true);
        if (this.emitters.onNotificationOpen) {
          this.emitters.onNotificationOpen(notificationSelected);
        }
        this.validateAndBuildDialogData(res, notificationSelected);
      }.bind(this),
      error: function(res) {
        this.loadingDialogData = false;
        var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
        this.toastMessage = message;
        this.$['toast-message'].show();
      }.bind(this)
    });
  },
  rightAnswers: function (results) {
    var count = 0;
    results.forEach(function(result){
      if (result.correct) {
        count += 1;
      }
    });
    return count;
  },
  mapQuizResults: function(answers, questions) {
    var results = [];
    for (var i = 0; i < questions.length; i ++) {
      var questionResult = questions[i].title + ' ' + (answers[i].correct ? '✓' : 'x');
      results.push(questionResult);
    }
    return results;
  },
  validateAndBuildDialogData: function(res, notificationSelected) {
    var action = this.actionsMapping[notificationSelected.data_type];
    if (action) {
      action(res, notificationSelected);
    }
  },
  openDialogConfirm: function (ev) {
    ev.stopPropagation();
    this.itemToRemove = null;
    var notificationSelected = ev.model.item;
    this.itemToRemove = notificationSelected;
    $(this.$['dialog-confirm']).show();
  },
  closeDialogConfirm: function(ev){
    $(this.$['dialog-confirm']).hide();
  },
  removeNotification: function() {
    var notificationSelected = this.itemToRemove;
    var index = this.notifications.indexOf(notificationSelected);
    if (index !== -1) {
      $.ajax({
        url: '/tutor/notifications/' + notificationSelected.id + '/remove',
        type: 'DELETE',
        success: function(res) {
          this.splice('notifications', index, 1);
          $(this.$['dialog-confirm']).hide();
          if (this.emitters.onNotificationRemoved) {
            this.emitters.onNotificationRemoved(notificationSelected);
          }
          this.async(function() {
            this.emptyNotifications = this.notifications.length === 0;
          }.bind(this));

        }.bind(this),
        error: function(res) {
          $(this.$['dialog-confirm']).hide();
          var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
          this.toastMessage = message;
          this.$['toast-message'].show();
        }.bind(this)
      });
    }
  },
  approvedRequest: function(ev) {
    this.answerRequest(ev, true);
  },
  disapprovedRequest: function(ev) {
    this.answerRequest(ev, false);
  },
  answerRequest: function (ev, answer) {
    ev.stopPropagation();
    var request_id = this.notificationSelected.data.new_request_content_id;
    var feedback = this.request_answer;
    $.ajax({
      url: '/api/content_validations/checked',
      type: 'POST',
      data: {
        request_id: request_id,
        message: feedback,
        approved: answer
      },
      success: function(res) {
        $(this.$['dialog-notification-info']).hide();
        this.clientNeedValidation = false;
      }.bind(this),
      error: function(res) {
        $(this.$['dialog-notification-info']).hide();
        var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
        this.toastMessage = message;
        this.$['toast-message'].show();
        this.clientNeedValidation = false;
      }.bind(this)
    });
  },
  updateFeedback: function(ev) {
    this.request_answer = ev.target.value;
  },
  buildClientTestCompleted: function(res, notificationSelected) {
    this.clientTestCompleted = true;
    var totalQuestions = res.questions.questions.length,
        successAnswers = this.rightAnswers(res.answers),
        description = 'Respondió ' + successAnswers + ' de ' + totalQuestions + ' preguntas correctamente',
        timeMessage = 'Tiempo usado: ' + res.time_quiz,
        answersWithResults =  this.mapQuizResults(res.answers, res.questions.questions),
        username = notificationSelected.client.username;

        this.notificationData =  {
          playerName: res.player_name,
          username: username,
          description: description,
          timeMessage: timeMessage,
          answers: answersWithResults
        };
  },
  buildClientMessageOpen: function(res, notificationSelected) {
    this.clientMessageOpen = true;
    var username = notificationSelected.client.username;
    this.notificationData =  {
      username: username,
      title: res.title,
      description: res.description,
      seenAt: res.seen_at
    };
  },
  buildClientGotItem: function(res, notificationSelected) {
    this.clientGotItem = true;
    var username = notificationSelected.client.username;
    this.notificationData =  {
      username: username,
      name: res.name,
      description: res.description
    };
  },
  buildClientRecommendedContentsCompleted: function(res, notificationSelected) {
    this.clientRecommendedContentsCompleted = true;
    var username = notificationSelected.client.username;
    this.notificationData =  {
      username: username,
      contents: res.contents || []
    };
  },
  buildClientNeedValidateAContent: function(res, notificationSelected) {
    this.clientNeedValidation = true;
    var username = notificationSelected.client.username;
    var request_client = res.request_client || {};
    var content_instruction = request_client.content_instruction || {};
    this.notificationData =  {
      username: username,
      content: request_client.content_title,
      media: request_client.media,
      text: request_client.text,
      instruction: content_instruction.description,
      media_required: !!content_instruction.media_required,
      created_at: request_client.created_at,
      reviewed: request_client.approved !== null,
      reviewed_by_me: request_client.reviewed_by_me,
      is_image: request_client.kind_of_file === 'image'
    };
    console.log(this.notificationData);
  },
  resetDialogFlags: function() {
    this.clientTestCompleted = false;
    this.clientMessageOpen = false;
    this.clientGotItem = false;
    this.clientRecommendedContentsCompleted =  false;
    this.clientNeedValidation = false;
  }
});
