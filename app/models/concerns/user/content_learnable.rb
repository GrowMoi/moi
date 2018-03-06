class User < ActiveRecord::Base
  module ContentLearnable
    include TreeService

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

    ##
    # @param name_branch [String]
    # @return [Array] wether if the user
    #   user contents learnt by branch
    def contents_learnt_by_branch(name)
      result = []
      neuron_branch = Neuron.where('lower(title) = ?', name.downcase).first
      if neuron_branch
        ids = TreeService::RecursiveChildrenIdsFetcher.new(
          neuron_branch
        ).children_ids
        ids = ids << neuron_branch.id
        all_contents = Neuron.approved_public_contents
        user_contents = self.content_learnings.map(&:content_id)
        contents_by_branch = find_contents(
                              ids,
                              all_contents
                            ).map(&:id)
        result = contents_by_branch & user_contents
      end
      result
    end

    private

    def find_contents(contents, all_contents)
      result = all_contents.select do |c|
        contents.include?(c.neuron_id)
      end
      result
    end
  end
end
