Polymer({
  is: 'moi-dialog',
  properties: {
    title: {
      type: String,
      default: ''
    },
    width: {
      type: Number,
      default: 300
    },
    theme: {
      type: String,
      default: ''
    }
  },
  ready: function() {
    var that;
    that = this;
    that.dialogWidth = "width: " + that.width + "px";
    $(that).css({
      position: 'fixed',
      zIndex: '1031',
      left: (($(window).width() - $(that).outerWidth()) / 2) - (that.width / 2),
      top: (($(window).height() - $(that).outerHeight()) / 2) - 200
    });
    if (that.theme && that.theme.length > 0) {
      $(that.$['moi-dialog-content']).addClass(that.theme);
    }
    return $(that).hide();
  },
  closeDialog: function() {
    return $(this).hide();
  }
});
