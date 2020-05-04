applyDatatables = ->
  $('.datatable').each ->
    columnDefs = []
    if $(this).data("includes-actions")
      # disable sorting on last column if the datatable
      # intends to display actions
      columnDefs.push { "targets": -1, "orderable": false }

    if $(this).data("includes-checkbox")
      columnDefs.push { "targets": 0, "orderable": false }

    table = $(this).dataTable
      sPaginationType: "full_numbers"
      bProcessing: true
      bServerSide: true
      sAjaxSource: $(this).data('source')
      columnDefs: columnDefs
      oLanguage:
        sUrl: "/datatables/datatables.es.txt"

    table.on "draw.dt", ->
      $(document).trigger "datatable:draw", table

# Listen for document.ready and page:load (turbolinks)
$(document).on "ready page:load", applyDatatables
