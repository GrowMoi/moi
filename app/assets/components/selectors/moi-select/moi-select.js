Polymer({
  is: 'moi-select',
  properties: {
    items: {
      type: Array,
      value: function() {
        return [];
      },
      observer: 'itemsLoaded'
    },
    placeholder: String,
    name: {
      type: String,
      default: ''
    }
  },
  ready: function() {
    var that;
    that = this;
    $(that.$.selector).on('change', function(e) {
      var val;
      val = $(e.target).val();
      that.fire('item-selected', val);
    });
  },
  itemsLoaded: function(newVal, oldVal) {
    var that = this;
    if ((oldVal !== undefined) && (newVal !== oldVal) ) {
      that.async(function() {
        that.fire('items-loaded', that);
      });

    }
  }
});
