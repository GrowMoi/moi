module PaperTrail
  class NotificationMediaVersionDecorator < VersionDecorator
    def initialize(*args)
      super(*args)
      ignore_keys "notification_id"
      mandatory_keys "media"
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.notification.#{key}")
    end
  end
end
