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
      result = []
      branches = Neuron.neurons_by_branches
      all_contents = Content.approved.all
      user_contents = self
                      .content_learnings
                      .map(&:content_id)
      branches.map do |branch|
        object = Hash.new
        object['branch'] = branch['title']
        contents_by_branch = find_contents(
                              branch['neurons_ids'],
                              all_contents
                            ).map(&:id)
        object['learnt_contents_ids'] = contents_by_branch & user_contents
        result << object
      end
      result
    end

    private

    def find_contents(contents, all_contents)
      result = all_contents.select do |c|
        contents.include?(c.neuron_id)
      end
      return result
    end
  end
end
