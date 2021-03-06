Polymer({
  is: 'moi-student-card-content',
  behaviors: [TranslateBehavior, AssetBehavior, UtilsBehavior],
  properties: {
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function() {
    this.init();
  },
  reload: function() {
    this.init();
  },
  init: function () {
    var studentsApi = '/tutor/dashboard/students';

    var currentUser =  UtilsBehavior.getCurrentUser() || {};
    this.isAdmin = currentUser.role === 'admin';
    this.students = [];
    this.studentsSelected = [];
    this.rowImgActive = this.assetPath('client_avatar_green.png');
    this.rowImgInactive = this.assetPath('client_avatar_inactive.png');
    this.rowImgCheck = this.assetPath('check_green.png');
    this.downloadBtnFilename = 'reporte_' + Date.now() + '.xls';
    this.downloadBtnFilenameV3 = 'reporte_' + Date.now() + '.xlsx';
    $(this.$.btnSelectiveDownload).addClass('disabled');
    $(this.$.btnAllDownload).addClass('disabled');
    this.emitters = {};
    this.loading = true;
    this.userRemove = null;
    this.exportHasError = false;
    this.usernames = [];
    this.reportItems = [
      { id: 'username', text: 'Nombre de usuario'},
      { id: 'name', text: 'Nombre real'},
      { id: 'email', text: 'Email'},
      { id: 'total_contents_learnt', text: 'Contenidos aprendidos en total'},
      { id: 'contents_learnt_branch_aprender', text: 'Contenidos aprendidos en rama Aprender'},
      { id: 'contents_learnt_branch_artes', text: 'Contenidos aprendidos en rama Artes'},
      { id: 'contents_learnt_branch_lenguaje', text: 'Contenidos aprendidos en rama Lenguaje'},
      { id: 'contents_learnt_branch_naturaleza', text: 'Contenidos aprendidos en rama Naturaleza'},
      { id: 'total_neurons_learnt', text: 'Neuronas aprendidas'},
      { id: 'used_time', text: 'Tiempo de uso'},
      { id: 'used_time_ms', text: 'Tiempo de uso en milisegundos'},
      { id: 'average_reading_time', text: 'Tiempo de lectura promedio'},
      { id: 'average_reading_time_ms', text: 'Tiempo de lectura promedio en milisegundos'},
      { id: 'images_opened_in_count', text: 'Imagenes abiertas'},
      { id: 'total_notes', text: 'Notas agregadas'},
      { id: 'total_achievements', text: 'Logros alcanzados'},
      { id: 'link_analysis', text: 'Enlace a vista de análisis'},
    ]
    this.availableSortItems = [
      { id: 'username', text: 'Nombre de usuario', sort: false},
      { id: 'email', text: 'Email', sort: false},
    ];

    var HALF = Math.round(this.reportItems.length / 2);
    this.reportItemsLeft = this.reportItems.slice(0, HALF);
    this.reportItemsRight = this.reportItems.slice(HALF, this.reportItems.length);
    this.reportOption = {
      firstStep: {
        visible: true
      },
      secondStep: {
        basic: {
          visible: false
        },
        questions: {
          visible: false
        }
      }
    };

    $.ajax({
      url: studentsApi,
      type: 'GET',
      success: function (res) {
        this.loading = false;
        this.students = res.data || [];
        var hasActiveUsers = this.students.find(function(item) {
          return item.status === "accepted"
        });
        if (hasActiveUsers) {
          $(this.$.btnAllDownload).removeClass('disabled');
        } else {
          $(this.$.btnAllDownload).addClass('disabled');
        }
      }.bind(this)
    });
  },
  bindOptions: function() {
    this.registerLocalApi();
  },
  onRowSelectedHandler: function (e, data) {
    var index = this.studentsSelected.indexOf(data);
    if (index !== -1) {
      this.splice('studentsSelected', index, 1);
    } else {
      this.push('studentsSelected', data);
    }
    if (this.studentsSelected.length > 0) {
      $(this.$.btnSelectiveDownload).removeClass('disabled');
    } else {
      $(this.$.btnSelectiveDownload).addClass('disabled');
    }
  },
  cancelRequest: function (ev) {
    var element = ev.target;
    $(element).addClass('disabled');
    $.ajax({
      url: '/tutor/user_tutors/' + ev.model.item.id,
      type: 'DELETE',
      data: {
        id: ev.model.item.id
      },
      success: function (res) {
        AnalyticsBehavior.track('send', 'event', 'Cancelar solicitud alumno ' + ev.model.item.username, 'Click');
        var index = this.students.indexOf(ev.model.item);
        if (index !== -1) {
          this.splice('students', index, 1);
        }
        this.toastMessage = res.message;
        this.$['toast-message'].show();
      }.bind(this),
      error: function(res) {
        var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
        this.toastMessage = message;
        this.$['toast-message'].show();
      }.bind(this)
    });
  },
  openDialogConfirm: function (ev) {
    ev.stopPropagation();
    this.userRemove = ev.model.item;
    this.username = {username: this.userRemove.username};
    $(this.$['dialog-confirm']).show();
  },
  closeDialog: function(ev){
    $(this.$['dialog-confirm']).hide();
  },
  removeUser: function (ev) {
    $.ajax({
      url: '/tutor/user_tutors/' + this.userRemove.id + '/remove_user',
      type: 'PUT',
      data: {
        id: this.userRemove.id
      },
      success: function (res) {
        AnalyticsBehavior.track('send', 'event', 'Remover alumno ' + this.userRemove.username, 'Click');
        var index = this.students.indexOf(this.userRemove);
        if (index !== -1) {
          this.splice('students', index, 1);
        }
        this.toastMessage = res.message;
        this.$['toast-message'].show();
        $(this.$['dialog-confirm']).hide();
        if (this.emitters.onStudentRemoved) {
          this.emitters.onStudentRemoved(this.userRemove);
        }
      }.bind(this),
      error: function(res) {
        var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
        this.toastMessage = message;
        this.$['toast-message'].show();
        $(this.$['dialog-confirm']).hide();
      }.bind(this)
    });
  },
  openReportDialog: function(ev) {
    ev.stopPropagation();
    this.backSelectReportOption()
    $(this.$['dialog-build-report']).show();
    this.exportHasError = false;
  },
  restoreReportOptionsVisibility: function() {
    this.set('reportOption.firstStep.visible', false);
    this.set('reportOption.secondStep.basic.visible', false);
    this.set('reportOption.secondStep.questions.visible', false);
  },
  selectReportOption: function(ev) {
    var optionSelected = ev.target.id || ev.target.parentElement.id;
    this.restoreReportOptionsVisibility();
    this.set('reportOption.secondStep.'+ optionSelected +'.visible', true);
    this.async(function() {
      this.buttonDownloadReport = this.$$('#download-new-report-button');
      $(this.buttonDownloadReport).addClass('disabled');
    }.bind(this));
  },
  backSelectReportOption: function(ev) {
    this.restoreReportOptionsVisibility();
    this.set('reportOption.firstStep.visible', true);
  },
  onReportSortItemSelected: function(e, val) {
    for(var i = 0; i < this.availableSortItems.length; i ++) {
      this.availableSortItems[i].sort = false;
    }
    var index = this.availableSortItems.findIndex(function(item) {return item.id === val});
    if (index >= 0) {
      this.availableSortItems[index].sort = true;
    }
  },
  onReportSortItemLoaded: function(e) {
    for(var i = 0; i < this.availableSortItems.length; i ++) {
      this.availableSortItems[i].sort = false;
    }
    this.availableSortItems[0].sort = true;
  },
  registerLocalApi: function() {
    if (this.options && this.options.onRegisterApi) {
      var api = this.createPublicApi();
      this.options.onRegisterApi(api);
    }
  },
  createPublicApi: function() {
    return {
      addStudent: this.addStudent.bind(this),
      onStudentRemoved: this.onStudentRemoved.bind(this),
      reload: this.reload.bind(this)
    };
  },
  addStudent: function(student) {
    student.status = false;
    this.push('students', student);
  },
  onStudentRemoved: function(callback) {
    this.emitters.onStudentRemoved = callback;
  },
  onCheckboxChangeLeft: function(ev) {
    this.checkboxChange(ev, this.reportItemsLeft);
  },
  onCheckboxChangeRight: function(ev) {
    this.checkboxChange(ev, this.reportItemsRight);
  },
  checkboxChange: function(ev, items) {
    var index = ev.target.id;
    items[index].checked = ev.target.checked;
  },
  onSubmitReportParams: function (ev) {
    ev.preventDefault();
    var sortItem = this.availableSortItems.find(function(item) {return item.sort}) || this.availableSortItems[0];
    var sort_by = sortItem.id;
    this.buttonDownloadReport = this.$$('#download-new-report-button');
    $(this.buttonDownloadReport).addClass('disabled');
    var req = new XMLHttpRequest();
    var mainUrl =
      "/tutor/dashboard/download_tutor_analytics_v2.xlsx?" +
      $.param({
        sort_by: sort_by,
        usernames: this.usernames
      });
    req.open("GET", mainUrl, true);
    req.responseType = "blob";
    req.onload = function(event) {
      if (event.target.status >= 400) {
        this.exportHasError = true;
      } else {
        var blob = req.response;
        var link = document.createElement("a");
        link.href = window.URL.createObjectURL(blob);
        link.download = this.downloadBtnFilenameV3;
        link.click();
        $(this.buttonDownloadReport).removeClass("disabled");
      }

    }.bind(this);

    req.send();
  },
  parseStudentsExcelFile: function(ev) {
    this.getUsernames(ev.target.files[0], function onSuccess(usernames) {
      $(this.buttonDownloadReport).removeClass('disabled');
      this.usernames = usernames;
    }.bind(this))
  },
  getUsernames: function(file, cb) {
    var reader = new FileReader();
    reader.onload = function(e) {
      var data = e.target.result;
      var workbook = XLSX.read(data, {
        type: 'binary'
      });
      workbook.SheetNames.forEach(function(sheetName) {
        var usernames = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName])
                  .filter(function(item) { return !!Object.values(item)[0] })
                  .map(function(item){ return Object.values(item)[0] });

        cb(usernames)
      })
    };

    reader.onerror = function(ex) {
      console.log(ex);
    };

    reader.readAsBinaryString(file);
  }
});
