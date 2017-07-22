module Admin
  class NotificationsController < AdminController::Base

    before_action :build_relationships!,
                  only: [:new, :create]

    authorize_resource

    expose(:notification, attributes: :notification_params)

    expose(:decorated_notification) {
      decorate notification
    }

    def index
      @notifications = Notification.all
      render
    end

    def new
      render
    end

    def create
      notification.user = current_user
      if notification.save
        redirect_to admin_notifications_path
      else
        render :new
      end
    end

    private

    def notification_params

      params.require(:notification).permit(
        :title,
        :description,
        :notification_videos_attributes => [
          :id,
          :url
        ],
        :notification_medium_attributes => [
          :id,
          :_destroy,
          :media,
          :media_cache
        ],
        :notification_links_attributes => [
          :id,
          :link
        ]
      )
    end

    def build_relationships!
      decorated_notification.build_one_link!
      decorated_notification.build_one_video!
    end
  end
end
