module Api
  class TutorsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    PAGE = 1
    PER_PAGE = 4

    def recommendations
      if data_format == "contents"
        build_contents
      else
        build_recommendations
      end
    end

    def details
      recommendations_handler = TutorService::RecommendationsHandler.new(current_user)
      total_recommendations = recommendations_handler.get_all
      recommendations_in_progress = recommendations_handler.get_in_progress
      recommendations_reached = recommendations_handler.get_reached
      recommendation_contents_pending = recommendations_handler.get_available

      render json: {
        details: {
          total_recommendations: total_recommendations.size,
          recommendations_in_progress: recommendations_in_progress.size,
          recommendations_reached: recommendations_reached.size,
          recommendation_contents_pending: recommendation_contents_pending.size

        }
      },
      status: :accepted
    end

    private

    def build_contents
      recommended_contents = TutorService::RecommendationsHandler.new(
        current_user
      ).get_available

      serialized_contents = ActiveModel::ArraySerializer.new(
        recommended_contents,
        scope: current_user,
        each_serializer: Api::ContentSerializer
      )
      contents = paginate_array(serialized_contents)
      resp = {
        contents: contents
      }
      send_response(contents, resp)
    end

    def build_recommendations
      recommendations_handler = TutorService::RecommendationsHandler.new(current_user)
      my_recommendations = recommendations_handler.get_all
      my_recommendations_in_progress = recommendations_handler.get_in_progress
      my_recommendations_reached = recommendations_handler.get_reached

      serialized_recommendations = ActiveModel::ArraySerializer.new(
        my_recommendations,
        scope: current_user,
        each_serializer: Api::TutorRecommendationSerializer
      )
      recommendations = paginate_array(serialized_recommendations)

      resp = {
        recommendations: recommendations,
        meta: {
          total_in_progress: my_recommendations_in_progress.count,
          total_reached: my_recommendations_reached.count
        }
      }

      send_response(recommendations, resp)
    end

    def send_response(data, resp)
      resp[:meta] = resp[:meta] || {}
      resp[:meta][:total_items] = data.total_count
      resp[:meta][:total_pages] = data.total_pages
      render json: resp,
      status: :accepted
    end

    def paginate_array(items)
      array_items = JSON.parse(items.to_json)
      Kaminari.paginate_array(array_items)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)

    end

    def data_format
      default_format = "recommendations"
      if params[:data_format] == "contents"
        "contents"
      else
        default_format
      end
    end

  end
end
