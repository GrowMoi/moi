class User < ActiveRecord::Base
  module ContentLearnable
    ##
    # @param contents [Array] array of contents
    # @return [Boolean] wether if the user
    #   has already learnt a content
    def already_learnt_any?(contents)
      ContentLearning.where(
        user: self,
        content: contents.pluck(:id)
      ).exists?
    end
  end
end
