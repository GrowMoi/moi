class CollectionSelectable
  constructor: (wrapper) ->
    @$wrapper = $(wrapper)
    @recordsSelected = []
    @$selectAll = @$wrapper.find(".select-all")

    @selectAllListener()
    @onTableDrawListener()
    @destroyActionListener()

  selectAllListener: ->
    @$selectAll.on "click", (e) =>
      checked = e.target.checked
      $selects = @$wrapper.find(".select-single-record")
      $selects.prop "checked", checked
      @reloadRecordsSelected()

  onTableDrawListener: ->
    $(document).on "datatable:draw", (e, table) =>
      @tableReloaded()

  tableReloaded: ->
    @recordsSelected = []
    @singleCheckboxListener()
    @reloadBatchActionsBtn()
    @$selectAll.prop "checked", false

  reloadRecordsSelected: ->
    @recordsSelected = []
    @$wrapper.find(".select-single-record:checked").each (i, checkbox) =>
      @recordsSelected.push checkbox.value
    @reloadBatchActionsBtn()

  reloadBatchActionsBtn: ->
    disabled = @recordsSelected.length == 0
    $btn = @$wrapper.find(".dropdown a[data-toggle=dropdown]")
    $btn.find(".records-count").text @recordsSelected.length
    $btn.prop "disabled", disabled
    if disabled
      $btn.attr "disabled", "disabled"
    else
      $btn.removeAttr "disabled"

  singleCheckboxListener: ->
    @$wrapper.find(".select-single-record").on "change", =>
      @reloadRecordsSelected()

  destroyActionListener: ->
    @$wrapper.find(".destroy-action").on "click", =>
      if window.confirm('¿Estás seguro?')
        @$wrapper.submit()

jQuery ->
  $(".collection-selectable").each (i, wrapper) ->
    new CollectionSelectable(wrapper)
