module Api
  class TutorsController < BaseController
    before_action :authenticate_user!

    respond_to :json

    PAGE = 1
    PER_PAGE = 4

    expose(:my_recommendations) {
      ClientTutorRecommendation.where(client: current_user, status: "in_progress");
    }

    def recommendations
      serialized_contents = ActiveModel::ArraySerializer.new(
        recommended_contents,
        scope: current_user,
        each_serializer: Api::ContentSerializer
      )
      contents = paginate_contents(serialized_contents)
      render json: {
        contents: contents,
        meta: {
          total_items: contents.total_count,
          total_pages: contents.total_pages
        }
      }, status: :accepted
    end

    private

    def recommended_contents
      user_contents = []
      my_recommendations.find_each do |r|
        array_contents = r.tutor_recommendation.content_tutor_recommendations.map do |ctr|
          ctr.content
        end
        user_contents.concat array_contents
      end
      user_contents.uniq.delete_if{|e|current_user.already_learnt?(e) || current_user.already_read?(e)}
    end

    def paginate_contents(contents)
      array_contents = JSON.parse(contents.to_json)
      Kaminari.paginate_array(array_contents)
              .page(params[:page] || PAGE)
              .per(params[:per_page] || PER_PAGE)

    end

  end
end
