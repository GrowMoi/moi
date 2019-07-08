Polymer({
  is: 'moi-profile-view',
  behaviors: [TranslateBehavior, UtilsBehavior, NotificationBehavior],
  properties: {
    tutorId: String
  },
  ready: function () {
    var path = location.pathname;
    AnalyticsBehavior.track('set', 'page', path);
    AnalyticsBehavior.track('send', 'pageview');

    var profileApi = '/tutor/profile/info';
    this.userInfo = {
      name: '',
      username: '',
      email: '',
      authorization_key: null
    };
    this.passwordData = {
      currentPassword: '',
      password: ''
    };
    this.passwordConfirmation = '';
    this.images = [];

    $.ajax({
      url: profileApi,
      type: 'GET',
      success: this.onGetProfileApiSuccess.bind(this),
      error:  this.onGetProfileApiError.bind(this)
    });
    this.btnSendProfile = $(this.$['btn-send-profile']);
    this.btnSendPassword = $(this.$['btn-send-password']);
    this.$['profile-form'].addEventListener('submit', this.onSubmitUserForm.bind(this));
    this.$['password-form'].addEventListener('submit', this.onSubmitPasswordForm.bind(this));
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));

    NotificationBehavior.startPusherForTutorAccount(this.tutorId, this.onNotificationReceived.bind(this));

  },
  onGetProfileApiSuccess: function(res) {
    this.userInfo = this.mergeObjectsWithSpecificProps(this.userInfo, res.user);
    this.authorization_key = res.authorization_key;
    this.images = this._toArray(res.images, this.authorization_key);
  },
  onGetProfileApiError: function(res) {
    this.$['flash-message'].error(res.message);
  },
  onSubmitUserForm: function(event) {
    event.preventDefault();
    var updatePasswordApi = '/tutor/profile';
    this.btnSendProfile.addClass('disabled');
    $.ajax({
      url: updatePasswordApi,
      data: {
        tutor: this.userInfo
      },
      type: 'PUT',
      success: this.onSubmitSuccess.bind(this),
      error:  this.onSubmitError.bind(this)
    });

  },
  onSubmitPasswordForm: function(event) {
    event.preventDefault();
    var passwordFormatOk = true;
    var hasWhiteSpaces = /^\s|\s$/.test(this.passwordData.password);
    if (hasWhiteSpaces) {
      var text = this.t('views.tutor.profile.password_space_warn');
      passwordFormatOk = confirm(text);
    }
    if (passwordFormatOk) {
      if (this.passwordData.password !== this.passwordConfirmation) {
        var message = this.t('views.tutor.profile.different_password');
        this.$['flash-message'].error(message);
      } else {
        this.submitPasswordForm();
      }
    }
  },
  submitPasswordForm:  function() {
    var userParams = this.convertKeysFromCamelToSnakeCase(this.passwordData);
    var updatePasswordApi = '/tutor/profile/update_password';
    this.btnSendPassword.addClass('disabled');
    $.ajax({
      url: updatePasswordApi,
      data: {
        tutor: userParams
      },
      type: 'PUT',
      success: this.onSubmitSuccess.bind(this),
      error:  this.onSubmitError.bind(this)
    });
  },
  onSubmitSuccess: function(res) {
    AnalyticsBehavior.track('send', 'event', 'Actualizar credenciales', 'Click');
    this.btnSendProfile.removeClass('disabled');
    this.btnSendPassword.removeClass('disabled');
    this.$['flash-message'].success(res.message);
  },
  onSubmitError: function(res) {
    this.btnSendProfile.removeClass('disabled');
    this.btnSendPassword.removeClass('disabled');
    var json = res.responseJSON || {};
    this.$['flash-message'].error(json.message);
  },
  onNotificationReceived: function(notification) {
    this.notificationCounter++;
    NotificationBehavior.applyBadgetEffect(this.$.moiBadge);
  },
  _toArray: function(obj, authorization_key) {
    return Object.keys(obj).map(function(key) {
      return {
        name: key,
        value: obj[key],
        match: key == authorization_key
      };
    });
  },
  check: function(key) {
    return key == this.authorization_key;
  },
  selectKey: function (e){
    var item = e.model.item,
        newImages = this.images.map(function(image){
          image.match = (image.name === item.name);
          return image;
        });
    var newArray = JSON.parse(JSON.stringify(newImages));
    this.images = newArray;
    this.userInfo.authorization_key = item.name;
  }
});
