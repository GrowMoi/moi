Polymer({
  is: 'moi-user-card-content',
  behaviors: [TranslateBehavior, AssetBehavior],
  ready: function () {
    this.searchValue = '';
    this.usersApi = '/tutor/dashboard/get_clients';
    this.sendRequestBtnApi = '/tutor/user_tutors';
    this.rowImgActive = this.assetPath('client_avatar.png');
    this.rowImgInactive = this.assetPath('client_avatar_inactive.png');
    this.rowImgCheck = this.assetPath('check_blue.png');
    this.inputIconImage = this.assetPath('icon_search.png');
    this.initValues();
    this.init();
  },
  init: function () {
    var _this = this;
    _this.loading = true;
    $(_this.$.btnsend).addClass('disabled');
    $(_this.$.listcontainer).scrollTop(0);
    $(_this.$.listcontainer).scroll(_this.debounce(function (e) {
      return _this.onListScroll(e);
    }, 200));
    return $.ajax({
      url: _this.usersApi,
      type: 'GET',
      data: {
        page: _this.count
      },
      success: function (res) {
        _this.loading = false;
        _this.clients = res.data;
        _this.totalItems = res.meta.total_items;
      }
    });
  },
  onListScroll: function (e) {
    var diff, elem, existsData, scrollBottom;
    var _this = this;
    elem = $(e.currentTarget);
    diff = elem[0].scrollHeight - elem.scrollTop();
    scrollBottom = Math.round(diff) <= elem.outerHeight();
    existsData = _this.clients.length < _this.totalItems;
    if (scrollBottom && existsData) {
      _this.loading = true;
      _this.count++;
      $(_this.$.listcontainer).addClass('stop-scrolling');
      $.ajax({
        url: _this.usersApi,
        type: 'GET',
        data: {
          page: _this.count,
          search: _this.searchValue
        },
        success: function (res) {
          _this.loading = false;
          _this.clients = _this.clients.concat(res.data);
          _this.totalItems = res.meta.total_items;
          $(_this.$.listcontainer).removeClass('stop-scrolling');
        }
      });
    }
  },
  onRowSelectedHandler: function (e, data) {
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
    var _this = this;
    _this.searchValue = value;
    _this.initValues();
    $(_this.$.btnsend).addClass('disabled');
    $.ajax({
      url: _this.usersApi,
      type: 'GET',
      data: {
        page: _this.count,
        search: value
      },
      success: function (res) {
        _this.loading = false;
        _this.clients = res.data;
        _this.totalItems = res.meta.total_items;
      }
    });
  },
  initValues: function () {
    this.count = 1;
    this.clients = [];
    this.loading = true;
    this.clientsSelected = [];
  }
});
