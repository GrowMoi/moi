module Api
  class ContentsController < BaseController
    api :POST,
        "/neurons/:neuron_id/contents/:content_id/learn",
        "a user learns a content"
    param :neuron_id, Integer
    param :content_id, Integer
    def learn
    end
  end
end