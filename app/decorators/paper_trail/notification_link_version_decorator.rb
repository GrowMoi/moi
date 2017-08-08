module PaperTrail
  class NotificationLinkVersionDecorator < VersionDecorator
    def initialize(*args)
      super(*args)
      ignore_keys "notification_id"
      mandatory_keys "link"
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.notification_link.#{key}")
    end
  end
end
