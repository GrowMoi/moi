module PaperTrail
  class ContentVersionDecorator < VersionDecorator
    private

    ignore_keys "neuron_id"

    def value_for(key, value)
      case key
      when "kind"
        t("views.contents.kinds.#{value}")
      when "level"
        t("views.contents.levels.#{value}")
      else
        super
      end
    end

    def localised_attr_for(key)
      t("activerecord.attributes.content.#{key}")
    end
  end
end
