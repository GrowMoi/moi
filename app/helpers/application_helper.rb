module ApplicationHelper
  ##
  # @param key [String] flash message key
  # @return [String] css class for a given flash
  #   key. This is considering we are using
  #   twitter bootstrap and it's default alerts
  def flash_message_class_for(key)
    case key
    when "notice"
      "success"
    when "error"
      "danger"
    when "alert"
      "warning"
    else
      key
    end
  end

  ##
  # Generates required markup to make a datatable.
  # @note Requires `:source` option
  #
  # @param options [Hash]
  # @yield Contents of the table
  # @option options [String] :source Source URL
  #   to fetch records from. Needs to respond
  #   to JSON
  # @option options [Boolean] :includes_actions (true)
  #   Option to make last column not sortable (So you
  #   can add actions in there)
  def datatable(options)
    defaults = { includes_actions: true }
    raise ArgumentError, ":source must be provided" if options[:source].blank?
    data = defaults.merge(options)
    content_tag :table, class: "datatable table table-striped", data: data do
      yield
    end
  end
end
