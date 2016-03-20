class User < ActiveRecord::Base
  module UserContentPreferenceable
    extend ActiveSupport::Concern

    included do
      after_create :create_content_preferences!
    end

    private

    ##
    # create necessary content preferences
    # without overriding existing ones
    def create_content_preferences!
      Content::KINDS.each do |kind|
        content_preferences.where(
          kind: kind
        ).first_or_create
      end
    end
  end
end
