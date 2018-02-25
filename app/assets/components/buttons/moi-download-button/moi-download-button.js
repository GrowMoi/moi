Polymer({
  is: 'moi-download-button',
  properties: {
    href: String,
    text: String,
    loadingText: String,
    filename: String,
    mimeType: String,
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
    this.prevText = this.text;
    this.text = this.loadingText;
    this.button = this.$['download-button'];
    $(this.button).addClass('disabled');
    that = this;
    $.ajax({
      url: that.href,
      type: 'GET',
      data: {
        ids: that.ids
      },
      success: function(res) {
        that.download.call(that, res);
      }
    });
  },
  download: function(res) {
    var downloadLink, file, that;
    that = this;
    file = new Blob([res], {
      type: that.mimeType
    });
    downloadLink = document.createElement('a');
    downloadLink.download = that.filename;
    downloadLink.href = window.URL.createObjectURL(file);
    downloadLink.style.display = 'none';
    downloadLink.click();
    that.text = that.prevText;
    $(that.button).removeClass('disabled');
  }
});
