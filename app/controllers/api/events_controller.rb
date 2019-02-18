module Api
  class EventsController < BaseController

    before_action :authenticate_user!

    expose(:event) {
      Event.find(params[:id])
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
        each_serializer: Api::EventSerializer
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
      events = Event.where(active: true)
      respond_with(
        events,
        each_serializer: Api::EventSerializer
      )
    end

    api :GET,
        "/events/:id",
        "Get an event."
    example %q{
      "event": {
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
    }
    def show
      respond_with(
        event,
        serializer: Api::EventSerializer
      )
    end
  end
end
