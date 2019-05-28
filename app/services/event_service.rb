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

  def get_notification_events_count
    events_availables = get_available_events()
    events = Event.where(id: events_availables).order(created_at: :asc)
    count = 0
    all_events_ids = get_all_events_ids()

    if super_event_available
      count = count + 1
    end

    events_first_week = get_first_week(events)
    if events_first_week.any?
      count = count + 1
    end

    unless (events.size == all_events_ids.size)
      events_second_week = get_second_week(events)
      if events_second_week.any?
        count = count + 1
      end
    end
    count
  end

  private

  def super_event_available
    super_event = EventAchievement.last
    unless super_event.is_expired
      if super_event.new_users && (@client.created_at > super_event.start_date)
        if @client.my_super_events.empty?
          super_event #no events user
        else
          if @client.my_super_events.find(super_event.id).nil?
            super_event
          else
            unless @client.super_event_completed?
              super_event
            end
          end
        end
      end
    end
  end

  def get_first_week(events)
    [events[0],events[1],events[2]].reject { |c| c.nil? }
  end

  def get_second_week(events)
    [events[3],events[4],events[5]].reject { |c| c.nil? }
  end

end
