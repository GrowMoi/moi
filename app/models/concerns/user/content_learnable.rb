class User < ActiveRecord::Base
  module ContentLearnable
    ##
    # make the user learn a content
    #
    # @param content [Content] content to learn
    def learn(content)
      return false if already_learnt?(content)

      content_learnings.create!(
        content: content
      )
    end

    ##
    # @param content [Content]
    # @return [Boolean] wether if the user
    #   has already learnt a content
    def already_learnt?(content)
      ContentLearning.where(
        user: self,
        content: content
      ).exists?
    end
  end
end
