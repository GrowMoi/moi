this.StudentBehavior = {
  formatStudentData: function(items) {
    return $.map(items, function(item) {
      var text;
      text = item.username;
      if (item.name) {
        text = item.name + " (" + item.username + ")";
      }
      return {
        id: item.id,
        text: text
      };
    });
  }
};
