class User < ActiveRecord::Base
  module ContentLearnable
    def learn(content)
      return false if already_learnt?(content)

      content_learnings.create!(
        content: content
      )
    end

    def already_learnt?(content)
      ContentLearning.where(
        user: self,
        content: content
      ).exists?
    end
  end
end
