module TutorService
  class RecommendationsStatusUpdater
    def initialize(client, recommendation, content_ids)
      @client = client
      @recommendation = recommendation
      @content_ids = content_ids
    end

    def perform

      recommendation_for_client = ClientTutorRecommendation.find_by(
        client: @client,
        tutor_recommendation: @recommendation
      )

      unless recommendation_for_client.present?
        recommendation_for_client = ClientTutorRecommendation.new(
          client: @client,
          tutor_recommendation: @recommendation
        )
      end

      client_content_learnings = ContentLearning.where(user: @client, content_id: @content_ids)
      if client_content_learnings.size == @content_ids.size
        recommendation_for_client.status = :reached
      else
        recommendation_for_client.status = :in_progress
      end
      recommendation_for_client.save
    end

  end
end
