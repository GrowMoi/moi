Polymer({
  is: 'moi-send-client-request-button',
  properties: {
    text: String,
    loadingText: String,
    sendRequestApi: String,
    ids: {
      type: Array({
        value: function() {
          return [];
        }
      })
    }
  },
  onClick: function() {
    var that;
    that = this;
    that.prevText = that.text;
    that.text = that.loadingText;
    $(that.$.btnsend).addClass('disabled');
    $.ajax({
      url: that.sendRequestApi,
      type: 'POST',
      data: {
        user_ids: that.ids
      }
    });
  }
});
