Polymer({
  is: 'moi-student-card-content',
  behaviors: [TranslateBehavior, AssetBehavior],
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
    this.students = [];
    this.studentsSelected = [];
    this.rowImgActive = this.assetPath('client_avatar_green.png');
    this.rowImgInactive = this.assetPath('client_avatar_inactive.png');
    this.rowImgCheck = this.assetPath('check_green.png');
    this.downloadBtnFilename = 'reporte_' + Date.now() + '.xls';
    $(this.$.btnSelectiveDownload).addClass('disabled');
    this.emitters = {};
    this.loading = true;
    this.userRemove = null;
    this.reportItems = [
      { id: 'username', text: 'Nombre de usuario'},
      { id: 'name', text: 'Nombre real'},
      { id: 'email', text: 'Email'},
      { id: 'images_opened_in_count', text: 'Imagenes abiertas'},
      { id: 'total_neurons_learnt', text: 'Neuronas aprendidas'},
      { id: 'average_reading_time', text: 'Tiempo de lectura promedio'},
      { id: 'average_reading_time_ms', text: 'Tiempo de lectura promedio en ms'},
      { id: 'used_time', text: 'Tiempo de uso'},
      { id: 'used_time_ms', text: 'Tiempo de uso en ms'},
      { id: 'total_contents_learnt', text: 'Contenidos aprendidos en total'},
      { id: 'contents_learnt_branch_aprender', text: 'Contenidos aprendidos en neurona Aprender'},
      { id: 'contents_learnt_branch_artes', text: 'Contenidos aprendidos en neurona Artes'},
      { id: 'contents_learnt_branch_lenguaje', text: 'Contenidos aprendidos en neurona Lenguaje'},
      { id: 'contents_learnt_branch_naturaleza', text: 'Contenidos aprendidos en neurona Naturaleza'},
      // { id: 'user_tests', text: ''},
      // { id: 'total_content_readings', text: ''},
      // { id: 'content_readings_by_branch', text: ''},
      // { id: 'total_right_questions', text: ''},
      //{ id: 'user_test_answers', text: ''},
      //{ id: 'user_sign_in_count', text: ''},
    ]

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
        this.students = res.data;
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
  },
  backSelectReportOption: function(ev) {
    this.restoreReportOptionsVisibility();
    this.set('reportOption.firstStep.visible', true);
  },
  onReportSortItemSelected: function() {

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
  }
});
