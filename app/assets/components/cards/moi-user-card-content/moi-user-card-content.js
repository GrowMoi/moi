Polymer({
  is: 'moi-user-card-content',
  behaviors: [TranslateBehavior],
  properties: {
    usersApi: String,
    sendRequestBtnClass: String,
    sendRequestBtnApi: String,
    rowImgActive: String,
    rowImgInactive: String,
    rowImgCheck: String,
    inputIconImage: String
  },
  ready: function() {
    this.searchValue = '';
    this.initValues();
    this.init();
  },
  init: function() {
    var that;
    this.loading = true;
    $(this.$.btnsend).addClass('disabled');
    $(this.$.listcontainer).scrollTop(0);
    that = this;
    $(this.$.listcontainer).scroll(this.debounce(function(e) {
      return that.onListScroll(e, that);
    }, 200));
    return $.ajax({
      url: that.usersApi,
      type: 'GET',
      data: {
        page: that.count
      },
      success: function(res) {
        that.loading = false;
        that.clients = res.data;
        that.totalItems = res.meta.total_items;
      }
    });
  },
  onListScroll: function(e, that) {
    var diff, elem, existsData, scrollBottom;
    elem = $(e.currentTarget);
    diff = elem[0].scrollHeight - elem.scrollTop();
    scrollBottom = Math.round(diff) <= elem.outerHeight();
    existsData = that.clients.length < that.totalItems;
    if (scrollBottom && existsData) {
      that.loading = true;
      that.count++;
      $(that.$.listcontainer).addClass('stop-scrolling');
      $.ajax({
        url: that.usersApi,
        type: 'GET',
        data: {
          page: that.count,
          search: that.searchValue
        },
        success: function(res) {
          that.loading = false;
          that.clients = that.clients.concat(res.data);
          that.totalItems = res.meta.total_items;
          $(that.$.listcontainer).removeClass('stop-scrolling');
        }
      });
    }
  },
  onRowSelectedHandler: function(e, data) {
    var index;
    index = this.clientsSelected.indexOf(data);
    if (index !== -1) {
      this.splice('clientsSelected', index, 1);
    } else {
      this.push('clientsSelected', data);
    }
    if (this.clientsSelected.length > 0) {
      $(this.$.btnsend).removeClass('disabled');
    } else {
      $(this.$.btnsend).addClass('disabled');
    }
  },
  debounce: function(func, delay) {
    var inDebounce;
    inDebounce = void 0;
    return function() {
      var args, context;
      context = this;
      args = arguments;
      clearTimeout(inDebounce);
      inDebounce = setTimeout((function() {
        func.apply(context, args);
      }), delay);
    };
  },
  onInputEnter: function(e, value) {
    var that;
    this.searchValue = value;
    this.initValues();
    $(this.$.btnsend).addClass('disabled');
    that = this;
    $.ajax({
      url: that.usersApi,
      type: 'GET',
      data: {
        page: that.count,
        search: value
      },
      success: function(res) {
        that.loading = false;
        that.clients = res.data;
        that.totalItems = res.meta.total_items;
      }
    });
  },
  initValues: function() {
    this.count = 1;
    this.clients = [];
    this.loading = true;
    this.clientsSelected = [];
  }
});
