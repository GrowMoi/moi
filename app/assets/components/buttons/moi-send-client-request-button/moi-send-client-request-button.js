Polymer({
  is: 'moi-send-client-request-button',
  properties: {
    text: String,
    loadingText: String,
    sendRequestApi: String,
    ids: {
      type: Array,
      value: function() {
        return [];
      }
    }
  },
  onClick: function() {
    var _this;
    _this = this;
    _this.prevText = _this.text;
    _this.text = _this.loadingText;
    $(_this.$.btnsend).addClass('disabled');
    $.ajax({
      url: _this.sendRequestApi,
      type: 'POST',
      data: {
        user_ids: _this.ids
      }
    });
  }
});
