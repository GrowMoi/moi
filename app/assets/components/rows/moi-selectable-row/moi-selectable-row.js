Polymer({
  is: 'moi-selectable-row',
  properties: {
    name: String,
    username: String,
    imgSelector: String,
    imgAvatarActive: String,
    imgAvatarInactive: String,
    selected: {
      type: Boolean,
      value: false
    },
    studentId: String
  },
  ready: function() {
    this.imgAvatar = this.imgAvatarInactive;
  },
  selectRow: function() {
    this.selected = !this.selected;
    if (this.selected) {
      this.imgAvatar = this.imgAvatarActive;
    } else {
      this.imgAvatar = this.imgAvatarInactive;
    }
    this.fire('row-selected', this.studentId);
  }
});
