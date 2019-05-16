class EventService
  def initialize(client)
    @client = client
  end

  def get_all_events_ids
    Event.where(active: true)
        .where("user_level <= ?", @client.level)
        .order(created_at: :asc)
        .map(&:id)
  end

  def get_outdate_user_events_ids
    date = Date.today
    @client.user_events
      .where("updated_at < ?",
        date.at_beginning_of_week
      ).map(&:event_id)
  end

  def get_events_ids_taken_by_user
    @client.user_events.map(&:event_id)
  end

  def get_available_events
    all_events_ids = get_all_events_ids()
    outdate_user_events_ids = get_outdate_user_events_ids()
    events_ids_taken_by_user = get_events_ids_taken_by_user()
    all_events_ids - outdate_user_events_ids - events_ids_taken_by_user
  end

end
