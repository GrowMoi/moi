class User < ActiveRecord::Base
  module ContentReadable
    ##
    # user reads a content
    #
    # @param content [Content] content to read
    def read(content)
      # Delete content of the content_tasks if there is
      ContentTask.where(
        user: self,
        content: content )
      .first.destroy! if ContentTask.where(
        user: self,
        content: content
      ).first

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
      check_if_should_remove_content_test?()
      ContentReading.where(
        user: self,
        content: content
      ).exists?
    end

    
    private

    def check_if_should_remove_content_test?()
      test = ContentLearningTest.where(completed: false, user: self).last
      if test
        ids = test.questions.map{|q| q["content_id"]}
        self.content_readings.where(content_id: ids).destroy_all
        test.destroy
      end
    end
  end
end
