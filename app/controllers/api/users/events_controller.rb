module Api
  module Users
    class EventsController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      expose(:event) {
        Event.find(params[:id])
      }

      expose(:in_progress_event) {
        UserEvent.where(
          user: user,
          completed: false,
          expired: false
        ).last
      }

      respond_to :json

      api :POST,
          "/users/events/:id/take",
          "take an event"
      param :id, String, required: true
      def take
        if event
          user_event = UserEvent.new
          user_event.user = current_user
          user_event.event = event
          user_event.save
          response = {
            status: :created,
            event: event,
            user_event: user_event
          }
        else
          response = { status: :unprocessable_entity }
        end
        render json: response,
               status: response[:status]
      end

      api :GET,
          "/users/events/my_events",
          "get events taken"

      def my_events
        events = UserEvent.where(user: user)
        response = {
          status: :created,
          events: events
        }
        render json: response,
               status: response[:status]
      end

      api :GET,
          "/users/events/active_event",
          "get last event in progress"

      def active_event
        event = in_progress_event
        response = {
          status: :created,
          event: event
        }
        render json: response,
               status: response[:status]
      end
    end
  end
end
