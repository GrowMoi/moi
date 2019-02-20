module Api
  class EventsController < BaseController

    before_action :authenticate_user!

    expose(:event) {
      Event.find(params[:id])
    }

    expose(:days) {
      Date::DAYNAMES
    }

    respond_to :json

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
      current_day = Time.now.strftime("%A")
      events = Event.where("'#{current_day}' = ANY (publish_days)")
      events = events.where(active: true)
      respond_with(
        events,
        each_serializer: Api::EventSerializer,
        scope: current_user
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
      # events = Event.where(active: true, user_level: current_user.level)
      events_ids = Event.where(active: true).map(&:id)
      user_events_ids = current_user.user_events.map(&:event_id)
      events_availables = events_ids - user_events_ids
      events = Event.where(id: events_availables)
      events_by_week = {}

      if events_availables.size == events_ids.size #any event taken
        date = Date.today
        start_week = date.at_beginning_of_week.strftime
        end_week = date.at_end_of_week.strftime
        first_week = "#{start_week} - #{end_week}"
        events_to_serialize = [events[0],events[1],events[2]].reject { |c| c.nil? }
        serialized = ActiveModel::ArraySerializer.new(
          events_to_serialize,
          each_serializer: Api::EventSerializer,
          scope: current_user
        )
        events_by_week[first_week] = serialized
      else
        date = Date.today
        start_week = date.at_beginning_of_week.strftime
        end_week = date.at_end_of_week.strftime
        first_week = "#{start_week} - #{end_week}"
        events_to_serialize_1 = [events[0],events[1],events[2]].reject { |c| c.nil? }
        serialized_first_week = ActiveModel::ArraySerializer.new(
          events_to_serialize_1,
          each_serializer: Api::EventSerializer,
          scope: current_user
        )
        events_by_week[first_week] = serialized_first_week

        date = Date.today
        start_week = date.at_beginning_of_week -  7 #days
        start_week = start_week.at_beginning_of_week.strftime
        end_week = date.at_end_of_week -  7 #day
        end_week = end_week.at_end_of_week.strftime
        second_week = "#{start_week} - #{end_week}"
        events_to_serialize_2 = [events[3],events[4],events[5]].reject { |c| c.nil? }
        serialized_second_week = ActiveModel::ArraySerializer.new(
          events_to_serialize_2,
          each_serializer: Api::EventSerializer,
          scope: current_user
        )
        events_by_week[second_week] = serialized_second_week
      end

      respond_with(
        events_by_week
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
  end
end
