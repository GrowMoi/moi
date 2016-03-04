module PaperTrail
  class NeuronVersionDecorator < VersionDecorator
    def changed_attrs
      changed_keys.map { |key|
        t("activerecord.attributes.neuron.#{key}").downcase
      }.join ", "
    end

    def time_ago
      t(
        "views.changelog.time_ago",
        time_ago: time_ago_in_words(created_at)
      )
    end

    def contents_changed?
      raw_contents.length > 0
      # may have to enhance:
      # Version.exists?(
      #   item_type: "Content",
      #   transaction_id: transaction_id
      # )
    end

    def medium_changed?
      raw_medium.length > 0
    end

    def changed_contents
      @changed_contents ||= decorate(
        raw_contents,
        ContentVersionDecorator
      )
    end

    def changed_medium
      @changed_medium ||= decorate(
        raw_medium,
        ContentMediaVersionDecorator
      )
    end

    def event_explanation
      t(
        "views.changelog.#{record.event}"
      ) + (changed_keys.any? ? ":" : "")
    end

    def changed_keys
      @changed_keys ||= changeset.keys + extra_keys
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.neuron.#{key}")
    end

    def value_for(key, value)
      case key
      when "parent_id"
        if value.present?
          Neuron.find(value).title
        else
          "-"
        end
      else
        super
      end
    end

    def extra_keys
      Array.new.tap do |keys|
        keys << "contents" if contents_changed?
        keys << "medium" if medium_changed?
      end
    end

    def raw_contents
      @raw_contents ||= Version.where(
        item_type: "Content",
        transaction_id: transaction_id
      )
    end

    def raw_medium
      @raw_medium ||= Version.where(
        item_type: "ContentMedia",
        transaction_id: transaction_id
      )
    end
  end
end
