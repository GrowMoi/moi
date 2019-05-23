module Admin
  class EventsController < AdminController::Base
    include Breadcrumbs

    before_action :add_breadcrumbs

    authorize_resource

    expose(:event, attributes: :event_params)
    expose(:events) {
      Event.order(created_at: :desc)
    }

    expose(:all_contents) {
      Neuron.approved_public_contents
    }

    expose(:days) {
      Date::DAYNAMES
    }

    expose(:contents) {
      Content.where(id: event.content_ids)
    }

    def create
      if event.save
        redirect_to admin_event_path(event), notice: I18n.t("views.events.created")
      else
        render :new
      end
    end

    def update
      if event.save
        redirect_to admin_event_path(event), notice: I18n.t("views.events.updated")
      else
        render :edit
      end
    end

    private

    def event_params
      params.require(:event).permit(*permitted_attributes)
    end

    def permitted_attributes
      allowed = [ :title,
                  :description,
                  :duration,
                  :kind,
                  :user_level,
                  :image,
                  :inactive_image,
                  :active,
                  content_ids: [],
                  publish_days: []
                ]
    end

    def resource
      @resource ||= event.id
    end

  end
end
