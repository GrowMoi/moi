class User < ActiveRecord::Base
  module ContentReadable
    ##
    # user reads a content
    #
    # @param content [Content] content to read
    def read(content)
      return false if already_read?(content)

      content_readings.create!(
        content: content
      )
    end

    ##
    # @param content [Content]
    # @return [Boolean] wether if the user
    #   has already read a content
    def already_read?(content)
      ContentReading.where(
        user: self,
        content: content
      ).exists?
    end
  end
end
