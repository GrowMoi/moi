jQuery ->
  $('.datatable').each ->
    $(this).dataTable
      sPaginationType: "full_numbers"
      bProcessing: true
      bServerSide: true
      sAjaxSource: $(this).data('source')
      columnDefs: [ { "targets": -1, "orderable": false } ]
      oLanguage:
        sUrl: "/datatables.es.txt"
