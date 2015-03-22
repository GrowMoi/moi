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

    def changed_contents
      @changed_contents ||= decorate(
        raw_contents,
        ContentVersionDecorator
      )
    end

    private

    def localised_attr_for(key)
      t("activerecord.attributes.neuron.#{key}")
    end

    def value_for(key, value)
      case key
      when "parent_id"
        Neuron.find(value).title
      else
        super
      end
    end

    def changed_keys
      changeset.keys + extra_keys
    end

    def extra_keys
      Array.new.tap do |keys|
        keys << "contents" if contents_changed?
      end
    end

    def raw_contents
      @raw_contents ||= Version.where(
        item_type: "Content",
        transaction_id: transaction_id
      )
    end
  end
end
