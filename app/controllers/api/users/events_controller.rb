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

      expose(:last_user_event_completed) {
        UserEvent.where(
          user: current_user,
          completed: true
        ).last
      }

      expose(:last_user_event_expired) {
        UserEvent.where(
          user: current_user,
          expired: true
        ).last
      }

      respond_to :json

      api :POST,
          "/users/events/:id/take",
          "take an event"
      param :id, String, required: true
      def take
        if event
          if user_can_take_event?
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
            response = {
              status: :unprocessable_entity,
              errors: [
                "Hay un evento en curso"
              ]
            }
          end
        else
          response = {
            status: 404
          }
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

      private

      def user_can_take_event?
        can_take_event = true
        if last_user_event_completed
          can_take_event = last_user_event_completed.completed
        end
        if last_user_event_expired
          can_take_event = last_user_event_expired.expired
        end
        can_take_event
      end
    end
  end
end
