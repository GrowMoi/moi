module Api
  class ContentsController < BaseController
    before_action :authenticate_user!

    expose(:content) {
      neuron.contents.find(params[:id])
    }

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/learn",
        "a user learns a content"
    param :neuron_id, Integer, required: true
    param :content_id, Integer, required: true
    def learn
      if current_user.learn(content)
        status = :created
      else
        status = :unprocessable_entity
      end
      render nothing: true,
             status: status
    end

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/notes",
        "a user takes notes of a content"
    param :neuron_id, Integer, required: true
    param :content_id, Integer, required: true
    param :notes, String, required: true
    def notes
      current_user.annotate_content(
        content,
        params[:note]
      )
      render nothing: true,
             status: :ok
    end
  end
end
