module Api
  class NotificationsController < BaseController
    PAGE = 1
    PER_PAGE = 2

    before_action :authenticate_user!

    expose(:my_tutors) {
      UserTutor.where(user: current_user, status: :accepted)
    }

    expose(:tutor_ids) {
      User.where(role: [:tutor, :tutor_familiar]).pluck(:id)
    }

    expose(:tutor_requests) {
      current_user.tutor_requests_received.pending
    }

    expose(:pending_notifications) {
      Notification.where.not(id: ReadNotification.where(user_id: current_user.id).pluck(:notifications_id))
    }

    expose(:tutor_notifications) {
      pending_notifications.where(user: my_tutors.pluck(:tutor_id))
                           .where(client_id: nil)
    }

    expose(:my_notifications) {
      pending_notifications.where(client: current_user)
    }

    expose(:admin_notifications) {
      pending_notifications.where.not(user: my_tutors.pluck(:tutor_id))
                           .where(client_id: nil)
                           .where.not(user: tutor_ids)
                           .where('created_at > ?', current_user.created_at)
    }

    expose(:user_notifications_count) {
      admin_notifications.count +
      tutor_requests.count +
      my_notifications.count +
      tutor_notifications.count
    }

    expose(:super_event_notification) {
      ClientNotification.where(client: current_user.id, deleted: false, data_type: 5).order(created_at: :desc)
    }

    expose(:content_validation_notification) {
      ClientNotification.where(client: current_user.id, deleted: false, data_type: 7).order(created_at: :desc)
    }

    expose(:total_user_notifications) {
      serialized_admin = serialize_notifications(
                            admin_notifications,
                            Api::GenericNotificationSerializer
                          ).as_json
      serialized_tutor_requests = serialize_notifications(
                            tutor_requests,
                            Api::UserTutorSerializer
                          ).as_json

      serialized_my_notifications = serialize_notifications(
                        my_notifications,
                        Api::GenericNotificationSerializer
                      ).as_json

      serialized_tutor_notifications = serialize_notifications(
                        tutor_notifications,
                        Api::GenericNotificationSerializer
                      ).as_json

      serialize_superevent_notifications = serialize_notifications(
                        super_event_notification,
                        Api::EventCompletedNotificationSerializer
                      ).as_json

      serialize_content_validation_notifications = serialize_notifications(
                        content_validation_notification,
                        Api::ClientNotificationSerializer
                      ).as_json

      serialize_superevent_notifications +
      serialized_my_notifications +
      serialized_tutor_requests +
      serialized_admin +
      serialized_tutor_notifications +
      serialize_content_validation_notifications
    }

    api :POST,
        "/notifications/:id/read_notifications",
        "To deleted a notification of a user."
    param :id, Integer, required: true
    param :data_type, String, required: false

    def read_notifications
      if params[:data_type] &&  params[:data_type] == "client_completed_super_event"
        current_notification_event = ClientNotification.find_by_id(params[:id])
        notification_event_deleted = current_notification_event.update(deleted: true)
        if notification_event_deleted
          render json: { deleted: notification_event_deleted },
              status: :ok
        else
          render json: { status: :unprocessable_entity },
              status: response[:status]
        end
      else
        init_read_notification = current_user.create_read_notification(params[:id])
        unless init_read_notification.nil?
          render json: { deleted: init_read_notification },
              status: :ok
        else
          render json: { status: :unprocessable_entity },
              status: response[:status]
        end
      end
    end

    api :GET,
        "/notifications",
        "get new notifications for current user"
    example %q{
      "notifications": [
        {
          "id": 14,
          "title": "Notification 1",
          "description": "Consequatur nesciunt neque accusamus ipsum consectetur",
          "user_id": 1,
          "videos": [
            "https://www.youtube.com/watch?v=JFOQc3tOT98"
          ],
          "media": [
            "1501675636-nature-q-c-640-480-2.jpg"
          ],
          "type": "generic",
          "created_at": "2017-08-02T07:07:14.351-05:00"
        },
        {
          "id": 13,
          "title": "Notification 2",
          "description": "Consequatur nesciunt neque accusamus ipsum consectetur",
          "user_id": 1,
          "videos": [
            "https://www.youtube.com/watch?v=JFOQc3tOT98"
          ],
          "media": [
            "1501621362-nature-q-c-640-480-2.jpg"
          ],
          "type": "generic",
          "created_at": "2017-08-01T16:02:41.576-05:00"
        },
        {
          "id": 1,
          "status": null,
          "tutor": {
            "id": 4,
            "email": "tutor1@test.com",
            "created_at": "2017-08-01T15:59:41.764-05:00",
            "updated_at": "2017-08-01T16:00:22.912-05:00",
            "name": "tutor1",
            "role": "tutor",
            "uid": "tutor1@test.com",
            "provider": "email",
            "birthday": null,
            "city": null,
            "country": null,
            "tree_image": {
              "url": null
            },
            "school": null
          },
          "type": "request",
          "created_at": "2017-08-01T16:00:33.895-05:00"
        }
      ],
      "meta": {
        "total_count": 11,
        "total_pages": 4
      }
    }
    def index
      notification_items = paginate_notifications(total_user_notifications)
      render json: {
        notifications: notification_items,
        meta: {
          total_count: notification_items.total_count,
          total_pages: notification_items.total_pages
        }
      }
    end


    api :GET,
        "/notifications/details",
        "Get total counter tasks"
    example %q{
      {
        "notifications": 10,
        "recommendations": 7,
        "events": 4
      }
    }

    def details
      recommended_content_ids = TutorService::RecommendationsHandler.new(current_user).get_recommended_content_ids()
      event_content_ids = get_event_content_ids()
      content_ids = (recommended_content_ids + event_content_ids).uniq

      response_json = {
        contents_to_learn: content_ids.count
      }

      available_events_count = EventService.new(
        current_user
      ).get_notification_events_count() || 0

      super_events_completed_count = super_event_notification.count
      notifications_count = available_events_count + user_notifications_count + super_events_completed_count
      response_json[NotificationService::NOTIFICATION_KEY] = notifications_count

      render json: response_json
    end

    api :GET,
    "/notifications/:id/open"
    param :id, Integer, required: true
    param :type, String, required: true
    param :tutor_id, String, required: true

    def open
      notification_type = params[:type]
      if notification_type == "tutor_generic"

        api_notification_id = params[:id]
        my_tutor = my_tutors.where(tutor_id: params[:tutor_id]).map(&:tutor).first
        my_notification = my_notifications.where(id: api_notification_id)
        previous_notification = ClientNotification.where("data->>'api_notification_id' = ?", api_notification_id)
        if !my_tutor
          return render json: {
            message: "Tutor not found"
          },
          status: 422
        end

        if my_notification && previous_notification.empty?
          client_notification = create_message_open_notification(api_notification_id)
          if client_notification
            notification_serialized = ClientNotificationSerializer.new(
              client_notification,
              root: false
            )
            notify_message_open_to_tutor(my_tutor.id, notification_serialized)

            return render nothing: true,
            status: :created
          end
        end
      end

      render nothing: true
    end

    private

    def paginate_notifications(notifications_data)
      sorted_notifications = sort_notifications(notifications_data)
      Kaminari.paginate_array(sorted_notifications)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)
    end

    def sort_notifications(notifications_data)
      notifications_data.sort_by {|elem| elem[:created_at]}.reverse
    end

    def serialize_notifications(notifications_data, serializer)
      serialized = ActiveModel::ArraySerializer.new(
        notifications_data,
        each_serializer: serializer
      )
      serialized
    end

    def serialize_tutor_notifications(notifications_data)
      serialized = ActiveModel::ArraySerializer.new(
        notifications_data,
        each_serializer: Api::UserTutorSerializer
      )
      serialized
    end

    def create_message_open_notification(api_notification_id)
      notification = ClientNotification.new
      notification.client_id = current_user.id
      notification.data_type = "client_message_open"
      notification.data = {
        api_notification_id: api_notification_id
      }
      return notification.save ? notification : nil;
    end

    def notify_message_open_to_tutor(tutor_id, notification_data)
      unless Rails.env.test?
        user_channel_general = "tutornotifications.#{tutor_id}"
        begin
          Pusher.trigger(user_channel_general, 'client_message_open', notification_data)
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        else
          puts "PUSHER: Message sent successfully!"
          puts "PUSHER: #{notification_data}"
        end
      end
    end

    def get_event_content_ids
      last_event = current_user.user_events.where(completed:false, expired:false).last
      event_content_ids = []
      unless last_event.nil?
        content_ids = last_event.contents.map { |item| item["content_id"].to_i }
        content_readings_ids = last_event.content_reading_events.map(&:content_id)
        event_content_ids = content_ids - content_readings_ids
      end
      event_content_ids
    end

  end
end
