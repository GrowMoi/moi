module TutorService
  class RecommendationsUpdater
    def initialize(client, tutor)
      @client = client
      @tutor = tutor
    end

    def update
      recommendations = @tutor.tutor_recommendations
      recommendations.find_each do |recommendation|
        content_ids = ContentTutorRecommendation.where(
          tutor_recommendation: recommendation
        ).map(&:content_id)
        if content_ids.any?
          TutorService::RecommendationsStatusUpdater.new(
            @client,
            recommendation,
            content_ids
          ).perform
        end
      end
    end

  end
end
