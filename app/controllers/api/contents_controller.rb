module Api
  class ContentsController < BaseController
    before_action :authenticate_user!

    expose(:content) {
      neuron.contents.find(params[:id])
    }

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/learn",
        "a user learns a content"
    param :neuron_id, Integer
    param :content_id, Integer
    def learn
      if current_user.learn(content)
        render nothing: true,
               status: :created
      else
        render nothing: true,
               status: :unprocessable_entity
      end
    end
  end
end
