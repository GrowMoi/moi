this.UtilsBehavior = {
  parseQueryString: function (query) {
    var vars = query.split("&");
    var queryString = {};
    for (var i = 0; i < vars.length; i++) {
      var pair = vars[i].split("=");
      if (typeof queryString[pair[0]] === "undefined") {
        queryString[pair[0]] = decodeURIComponent(pair[1]);
      } else if (typeof queryString[pair[0]] === "string") {
        var arr = [queryString[pair[0]], decodeURIComponent(pair[1])];
        queryString[pair[0]] = arr;
      } else {
        queryString[pair[0]].push(decodeURIComponent(pair[1]));
      }
    }
    return queryString;
  },
  getQueryUrlParams: function () {
    return window.location.search.substring(1) || '';
  },
  getCurrentUrlParams: function () {
    var query = this.getQueryUrlParams();
    return this.parseQueryString(query);
  },
  convertObjectToArrayItems: function (objectData) {
    var res = [];
    $.each(objectData, function (key, value) {
      res.push({
        label: key,
        value: value
      });
    });
    return res;
  },
  addParamToUrl: function (stateName, paramName, value) {
    var url = window.location.href.split('?')[0];
    if (url) {
      window.history.pushState(stateName, '', url + '?' + paramName + '=' + value);
    }
  }

};
