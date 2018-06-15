Polymer({
  is: 'moi-user-card-content',
  behaviors: [TranslateBehavior, AssetBehavior, NotificationBehavior],
  ready: function () {
    this.searchValue = '';
    this.usersApi = '/tutor/dashboard/get_clients';
    this.sendRequestBtnApi = '/tutor/user_tutors';
    this.rowImgActive = this.assetPath('client_avatar.png');
    this.rowImgInactive = this.assetPath('client_avatar_inactive.png');
    this.rowImgCheck = this.assetPath('check_blue.png');
    this.inputIconImage = this.assetPath('icon_search.png');
    this.rowApis = [];
    this.rowOptions = {
      onRegisterApi: function(api) {
        this.rowApis.push(api);
      }.bind(this)
    }
    this.initValues();
    this.init();
  },
  init: function () {
    this.loading = true;
    $(this.$.btnsend).addClass('disabled');
    $(this.$.listcontainer).scrollTop(0);
    $(this.$.listcontainer).scroll(this.debounce(function (e) {
      return this.onListScroll(e);
    }, 200).bind(this));
    $.ajax({
      url: this.usersApi,
      type: 'GET',
      data: {
        page: this.count
      },
      success: function(res) {
        this.loading = false;
        this.clients = res.data;
        this.totalItems = res.meta.total_items;
      }.bind(this)
    });
  },
  onListScroll: function (e) {
    var diff, elem, existsData, scrollBottom;
    elem = $(e.currentTarget);
    diff = elem[0].scrollHeight - elem.scrollTop();
    scrollBottom = Math.round(diff) <= elem.outerHeight();
    existsData = this.clients.length < this.totalItems;
    if (scrollBottom && existsData) {
      this.loading = true;
      this.count++;
      $(this.$.listcontainer).addClass('stop-scrolling');
      $.ajax({
        url: this.usersApi,
        type: 'GET',
        data: {
          page: this.count,
          search: this.searchValue
        },
        success: function (res) {
          this.loading = false;
          this.clients = this.clients.concat(res.data);
          this.totalItems = res.meta.total_items;
          $(this.$.listcontainer).removeClass('stop-scrolling');
        }.bind(this)
      });
    }
  },
  onRowSelectedHandler: function (e, data) {
    var index = this.clientsSelected.indexOf(data);
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
  debounce: function (func, delay) {
    var inDebounce;
    inDebounce = void 0;
    return function () {
      var args, context;
      context = this;
      args = arguments;
      clearTimeout(inDebounce);
      inDebounce = setTimeout((function () {
        func.apply(context, args);
      }), delay);
    };
  },
  onInputEnter: function (e, value) {
    this.searchValue = value;
    this.initValues();
    $(this.$.btnsend).addClass('disabled');
    $.ajax({
      url: this.usersApi,
      type: 'GET',
      data: {
        page: this.count,
        search: value
      },
      success: function (res) {
        this.loading = false;
        this.clients = res.data;
        this.totalItems = res.meta.total_items;
      }.bind(this)
    });
  },
  initValues: function () {
    this.count = 1;
    this.clients = [];
    this.loading = true;
    this.clientsSelected = [];
  },
  onRequestSuccess: function(event, res) {
    this.toastMessage = res.message;
    this.$['toast-message'].show();
    this.clientsSelected = [];
    $(this.$.btnsend).addClass('disabled');
    this.resetAllRows();
  },
  onRequestError: function(event, res) {
    this.toastMessage = res.responseJSON.message;
    this.$['toast-message'].show();
    if (res.responseJSON.type === 'limit_exceeded') {
      $(this.$['dialog-info']).show();
    }
  },
  resetAllRows: function() {
    if (this.rowApis && this.rowApis.length > 0) {
      this.rowApis.forEach(function(api) {
        api.reset();
      });
    }
  }
});
