Polymer({
  is: 'moi-download-button',
  properties: {
    href: String,
    text: String,
    loadingText: String,
    filename: String,
    mimeType: String
  },
  onClick: function () {
    var manager = this;
    manager.prevText = manager.text;
    manager.text = manager.loadingText;
    manager.button = manager.$['download-button'];
    $(manager.button).addClass('disabled');
    $.ajax({
      url: manager.href,
      type: 'GET',
      success: function (res) {
        manager.download.call(manager, res);
      }
    });
  },
  download: function (res) {
    var manager = this;
    var file = new Blob([res], { type: manager.mimeType });
    var downloadLink = document.createElement('a');
    downloadLink.download = manager.filename;
    downloadLink.href = window.URL.createObjectURL(file);
    downloadLink.style.display = 'none';
    downloadLink.click();
    manager.text = manager.prevText;
    $(manager.button).removeClass('disabled');
  }

});
