module TutorService
  class RecommendationsHandler
    def initialize(client)
      @client = client
    end

    def get_all
      ClientTutorRecommendation.where(client: @client)
    end

    def get_in_progress
      get_all.where(status: "in_progress").includes(:tutor_recommendation)
    end


    def get_reached
      get_all.where(status: "reached").includes(:tutor_recommendation)
    end

    def get_available
      user_contents = []
      get_in_progress.find_each do |r|
        array_contents = ContentTutorRecommendation.includes(:content)
                                                   .where(tutor_recommendation: r.tutor_recommendation)
                                                   .map(&:content)
        user_contents.concat array_contents
      end
      user_contents.uniq.delete_if{|e|@client.already_learnt?(e) || @client.already_read?(e)}.reverse
    end

  end
end
