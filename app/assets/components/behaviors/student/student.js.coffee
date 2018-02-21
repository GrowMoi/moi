@StudentBehavior =
  formatStudentData: (items) ->
    return $.map(items, (item) ->
      text = item.username

      if item.name
        text = "#{item.name} (#{item.username})"

      return {
        id: item.id
        text: text
      }
    )
