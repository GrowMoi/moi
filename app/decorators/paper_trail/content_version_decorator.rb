module PaperTrail
  class ContentVersionDecorator < VersionDecorator
    private

    def value_for(key, value)
      case key
      when "kind"
        t("views.contents.kinds.#{value}")
      else
        super
      end
    end

    def localised_attr_for(key)
      t("activerecord.attributes.content.#{key}")
    end

    def ignored_keys
      %w(neuron_id)
    end
  end
end
