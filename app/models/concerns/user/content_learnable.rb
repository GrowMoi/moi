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

    def contents_learnt_by_branches
      branches = Neuron.neurons_by_branches
      all_contents = Content.approved.all.map(&:id)
      user_contents = self.content_learnings.map(&:content_id)
      result = []
      branches.map do |branch|
        learnt_contents = Hash.new
        learnt_contents['branch'] = branch['title']
        contents_by_branch = Content.approved.where(neuron_id: branch['neuron_ids']).map(&:id)
        learnt_contents['learnt_content_ids'] = contents_by_branch & user_contents
        result << learnt_contents
      end
      result
    end
  end
end
