module PaperTrail
  class NotificationVideoVersionDecorator < VersionDecorator
    def initialize(*args)
      super(*args)
      ignore_keys "notification_id"
      mandatory_keys "url"
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.notification_video.#{key}")
    end
  end
end
