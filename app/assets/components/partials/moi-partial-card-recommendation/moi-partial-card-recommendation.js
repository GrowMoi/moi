Polymer({
  is: 'moi-partial-card-recommendation',
  behaviors: [TranslateBehavior, RecommendationFormBehavior],
  properties: {
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function() {
    this.checkboxStatus = false;
  },
  bindOptions: function() {
    this.emitters = {};
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
      onCheckboxChange: this.loadOnCheckboxChangeCb.bind(this),
      disableSelector: this.disableSelector.bind(this)
    };
  },
  loadOnCheckboxChangeCb: function(cb) {
    this.emitters.onCheckboxChange = cb;
  },
  onCheckboxChange: function() {
    this.checkboxStatus = !this.checkboxStatus;
    if (this.emitters.onCheckboxChange) {
      this.emitters.onCheckboxChange(this.checkboxStatus);
    }
  },
  disableSelector: function(disable) {
    if (disable) {
      $(this.$$('#studentSelector')).addClass('disabled');
    } else {
      $(this.$$('#studentSelector')).removeClass('disabled');
    }

  }
});
