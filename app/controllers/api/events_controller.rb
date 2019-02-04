module Api
  class EventsController < BaseController

    before_action :authenticate_user!

    expose(:event) {
      Event.find(params[:id])
    }

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
          "kind": "public"
        },
        {
          "title": "Evento rama verder",
          "description": "Completa todos estos contenidos y haz crecer tu arbol",
          "id: 32,
          "image": "https://cdn4.iconfinder.com/data/icons/badges-and-votes-1/128/Badges_Votes_star-512.png",
          "duration": 120,
          "user_level": 5,
          "kind": "public"
        }
      ]
    }
    def today
      current_day = Time.now.strftime("%A")
      events = Event.where("'#{current_day}' = ANY (publish_days)")

      respond_with(
        events,
        serializer: Api::EventSerializer
      )
    end


    def show
      respond_with(
        event,
        serializer: Api::EventSerializer
      )
    end
  end
end
