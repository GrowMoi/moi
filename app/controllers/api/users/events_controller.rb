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

      expose(:super_event) {
        EventAchievement.find(params[:id])
      }

      expose(:last_user_event) {
        current_user.user_events.last
      }

      respond_to :json

      api :POST,
          "/users/events/:id/take",
          "take an super event"
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

      api :POST,
          "/users/events/:id/take_super_event",
          "take an event"
      param :id, String, required: true
      def take_super_event
        if super_event
          user_event = UserEventAchievement.new(
            user: current_user,
            event_achievement: super_event
          )
          user_event.save
          response = {
            status: :created,
            super_event: super_event
          }
        else
          response = {
            status: :not_found
          }
        end
        render json: response,
               status: response[:status]
      end

      api :GET,
          "/users/events/my_events",
          "get events taken"

      def my_events
        events = UserEvent.where(
                            user: user,
                            completed: true
                          ).order("updated_at DESC")
        response = {
          status: :accepted,
          events: events_serialize(events),
          meta: {
            total_events: Event.where(active: true)
                          .where("user_level <= ?", current_user.level)
                          .count,
            events_completed: events.count
          }
        }
        render json: response,
               status: response[:status]
      end

      private

      def user_can_take_event?
        unless last_user_event.nil?
          if last_user_event.completed || last_user_event.expired
            return true
          else
            return false
          end
        else
          return true
        end
      end

      def events_serialize(events)
        serialized = ActiveModel::ArraySerializer.new(
          events,
          each_serializer: Api::EventCompleteSerializer
        )
        serialized
      end
    end
  end
end
