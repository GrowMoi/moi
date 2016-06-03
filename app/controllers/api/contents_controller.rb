module Api
  class ContentsController < BaseController
    before_action :authenticate_user!

    expose(:content) {
      neuron.contents.find(params[:id])
    }

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/read",
        "a user reads a content"
    param :neuron_id, Integer, required: true
    param :content_id, Integer, required: true
    def read
      if current_user.read(content)
        status = :created
      else
        status = :unprocessable_entity
      end
      render nothing: true,
             status: status
    end

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/notes",
        "To store the notes a user takes of a content. IMPORTANT: If no notes are given then current notes are **deleted** from DB"
    param :neuron_id, Integer, required: true
    param :content_id, Integer, required: true
    param :notes, String
    def notes
      if params[:note].present?
        current_user.annotate_content(
          content,
          params[:note]
        )
      else
        current_user.unannotate_content!(content)
      end
      render nothing: true,
             status: :ok
    end
  end
end
