module Api
  class EventsController < BaseController

    before_action :authenticate_user!

    expose(:super_event_available) {
      super_event = EventAchievement.last
      unless super_event.is_expired
        if super_event.new_users && (current_user.created_at > super_event.start_date)
          if current_user.my_super_events.empty?
            super_event #no events user
          else
            if current_user.my_super_events.find(super_event.id).nil?
              super_event
            else
              unless current_user.super_event_completed?
                super_event
              end
            end
          end
        end
      end
    }

    expose(:event) {
      Event.find(params[:id])
    }

    expose(:days) {
      Date::DAYNAMES
    }

    respond_to :json

    api :GET,
        "/events",
        "Returns all events"
    example %q{
      "events": [
        {
          "title": "Evento mind blow",
          "description": "Completa todos estos contenidos y se un master",
          "id: 12,
          "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "inactive_image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "duration": 120,
          "user_level": 2,
          "kind": "public",
          "contents": [
            {
              content_id: 123,
              neuron: Jugar
            },
            {
              content_id: 125,
              neuron: Matematica
            }
          ]
        }
      ]
    }
    def index
      respond_with(
        serializeEvents(Event.all)
      )
    end

    api :GET,
        "/events/today",
        "Get events by day."
    example %q{
      "events": [
        {
          "title": "Evento mind blow",
          "description": "Completa todos estos contenidos y se un master",
          "id: 12,
          "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "inactive_image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "duration": 120,
          "user_level": 2,
          "kind": "public",
          "contents": [
            {
              content_id: 123,
              neuron: Jugar
            },
            {
              content_id: 125,
              neuron: Matematica
            }
          ]
        },
        {
          "title": "Evento rama verder",
          "description": "Completa todos estos contenidos y haz crecer tu arbol",
          "id: 32,
          "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "inactive_image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "duration": 120,
          "user_level": 5,
          "kind": "public",
          "contents": [
            {
              content_id: 123,
              neuron: Matematica
            },
            {
              content_id: 125,
              neuron: Ciencia
            }
          ]
        }
      ]
    }
    def today
      events = get_events_availables[:events]
      today = get_first_week(events)
      respond_with(
        today
      )
    end

    api :GET,
        "/events/week",
        "Get events by week."
    example %q{
      "events": [
        {
          "title": "Evento mind blow",
          "description": "Completa todos estos contenidos y se un master",
          "id: 12,
          "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "inactive_image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "duration": 120,
          "user_level": 2,
          "kind": "public",
          "contents": [
            {
              content_id: 123,
              neuron: Jugar
            },
            {
              content_id: 125,
              neuron: Matematica
            }
          ]
        },
        {
          "title": "Evento rama verder",
          "description": "Completa todos estos contenidos y haz crecer tu arbol",
          "id: 32,
          "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "inactive_image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "duration": 120,
          "user_level": 5,
          "kind": "public",
          "contents": [
            {
              content_id: 123,
              neuron: Matematica
            },
            {
              content_id: 125,
              neuron: Ciencia
            }
          ]
        }
      ]
    }
    def week
      respond_with(
        events_week
      )
    end

    api :GET,
        "/events/:id",
        "Get an event."
    example %q{
      "event": {
        "title": "Evento rama verder",
        "description": "Completa todos estos contenidos y haz crecer tu arbol",
        "id": 32,
        "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
        "inactive_image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
        "duration": 120,
        "user_level": 5,
        "kind": "public",
        "contents": [
          {
            content_id: 123,
            neuron: Matematica
          },
          {
            content_id: 125,
            neuron: Ciencia
          }
        ]
      }
    }
    def show
      respond_with(
        event,
        serializer: Api::EventSerializer,
        scope: current_user
      )
    end

    private

    def get_events_availables
      date = Date.today
      all_events_ids = Event.where(active: true)
                  .where("user_level <= ?", current_user.level)
                  .order(created_at: :asc)
                  .map(&:id)

      outdate_user_events_ids = current_user
                                .user_events
                                .where("updated_at < ?",
                                  date.at_beginning_of_week
                                ).map(&:event_id)

      events_ids_taken_by_user = current_user.user_events.map(&:event_id)

      events_availables = all_events_ids - outdate_user_events_ids - events_ids_taken_by_user
      events = Event.where(id: events_availables).order(created_at: :asc)
      result = {
        events: events || [],
        all_events_ids: all_events_ids || [],
        outdate_user_events_ids: outdate_user_events_ids || [],
        user_events: current_user.user_events
      }
    end

    def events_week()
      date = Date.today
      start_week = date.at_beginning_of_week.strftime
      end_week = date.at_end_of_week.strftime
      events_availables = get_events_availables
      events = events_availables[:events]
      all_events_ids = events_availables[:all_events_ids]
      events_by_week = {}

      if super_event_available
        events_by_week[:super_event] = serializeSuperEvent([super_event_available])
      end

      if (events.size == all_events_ids.size) && ()#any event taken
        first_week = "#{start_week} - #{end_week}"
        events_by_week[first_week] = get_first_week(events)
      else
        first_week = "#{start_week} - #{end_week}"
        events_by_week[first_week] = get_first_week(events)

        start_week = (date.at_beginning_of_week -  7).at_beginning_of_week.strftime
        end_week = (date.at_end_of_week -  7).at_end_of_week.strftime
        second_week = "#{start_week} - #{end_week}"
        events_by_week[second_week] = get_second_week(events)
      end
      events_by_week
    end

    def get_first_week(events)
      events_to_serialize = [events[0],events[1],events[2]].reject { |c| c.nil? }
      serializeEvents(events_to_serialize)
    end

    def get_second_week(events)
      events_to_serialize = [events[3],events[4],events[5]].reject { |c| c.nil? }
      serializeEvents(events_to_serialize)
    end

    def serializeEvents(events)
      serialized = ActiveModel::ArraySerializer.new(
        events,
        each_serializer: Api::EventSerializer,
        scope: current_user
      )
      serialized
    end

    def serializeSuperEvent(events)
      serialized = ActiveModel::ArraySerializer.new(
        events,
        each_serializer: Api::EventAchievementSerializer,
        scope: current_user
      )
      serialized
    end
  end
end
