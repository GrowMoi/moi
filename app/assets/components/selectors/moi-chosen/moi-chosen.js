Polymer({
  is: 'moi-chosen',
  properties: {
    items: {
      type: Array,
      value: function() {
        return [];
      }
    },
    placeholder: String
  },
  observers: ['updateChosen(items.*)'],
  updateChosen: function(items) {
    var that;
    that = this;
    if (items.value.length > 0) {
      this.async(function() {
        return $(that.$.chosenselector).chosen({
          no_results_text: I18n.t('views.tutor.common.nothing_found'),
          width: '100%'
        }).change(function(e, val) {
          var key;
          key = Object.keys(val)[0];
          if (key === 'selected') {
            that.fire('item-selected', val[key]);
          }
          if (key === 'deselected') {
            return that.fire('item-deselected', val[key]);
          }
        });
      });
    }
  }
});
