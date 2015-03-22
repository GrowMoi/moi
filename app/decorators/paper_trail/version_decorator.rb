module PaperTrail
  class VersionDecorator < LittleDecorator
    def user
      @user ||= decorate User.find(whodunnit)
    end

    def changes
      changeset.inject({}) do |memo, (key, value)|
        attribute = localised_attr_for(key)
        memo[attribute] = value_for(key, value.last)
        memo
      end
    end

    private

    def localised_attr_for(key)
      raise NotImplementedError
    end

    def value_for(key, value)
      value
    end

    def changeset
      @changeset ||= record.changeset.except(*ignored_keys)
    end

    def ignored_keys
      %w(updated_at)
    end
  end
end
