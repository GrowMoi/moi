module PaperTrail
  class VersionDecorator < LittleDecorator
    def user
      @user ||= decorate User.find(whodunnit)
    end

    def changed_attrs
      changeset.keys.map { |key|
        t("activerecord.attributes.neuron.#{key}").downcase
      }.join ", "
    end

    def time_ago
      t(
        "views.changelog.time_ago",
        time_ago: time_ago_in_words(created_at)
      )
    end
  end
end
