module Api
  class ContentsController < BaseController
    before_action :authenticate_user!

    expose(:content) {
      neuron.contents.find(params[:id])
    }

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/read",
        "a user reads a content. response includes test if needed"
    description "If a test should be triggered, then the test is included as part of the response body. See an example"
    param :neuron_id, Integer, required: true
    param :content_id, Integer, required: true
    example %q{
      // respuesta sin test
      {
        "status":"created",
        "perform_test":false,
        "test":null
      }
    }
    example %q{
      // respuesta con test
      {
        "status":"created",
        "perform_test":true,
        "test": {
          "id": 1,
          "questions": [
            {
              "content_id":6,
              "title":"Content 6",
              "media_url": "some_url",
              "possible_answers":[
                {
                  "id":7,
                  "text":"Possible answer 7"
                },
                {
                  "id":8,
                  "text":"Possible answer 8"
                },
                {
                  "id":9,
                  "text":"Possible answer 9"
                }
              ]
            },
            {
              "content_id":7,
              "title":"Content 7",
              "media_url": null,
              "possible_answers":[
                {
                  "id":10,
                  "text":"Possible answer 10"
                },
                {
                  "id":11,
                  "text":"Possible answer 11"
                },
                {
                  "id":12,
                  "text":"Possible answer 12"
                }
              ]
            },
            {
              "content_id":8,
              "title":"Content 8",
              "media_url": "some_url",
              "possible_answers":[
                {
                  "id":13,
                  "text":"Possible answer 13"
                },
                {
                  "id":14,
                  "text":"Possible answer 14"
                },
                {
                  "id":15,
                  "text":"Possible answer 15"
                }
              ]
            },
            {
              "content_id":9,
              "title":"Content 9",
              "media_url": "some_url",
              "possible_answers":[
                {
                  "id":16,
                  "text":"Possible answer 16"
                },
                {
                  "id":17,
                  "text":"Possible answer 17"
                },
                {
                  "id":18,
                  "text":"Possible answer 18"
                }
              ]
            }
          ]
        }
      }
    }
    def read
      if current_user.read(content)
        response = {
          status: :created,
          perform_test: test_fetcher.perform_test?,
          test: test_fetcher.user_test_for_api
        }
      else
        response = { status: :unprocessable_entity }
      end
      render json: response,
             status: response[:status]
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

    api :POST,
        "/neurons/:neuron_id/contents/:content_id/media_open",
        ""
    def media_open
      if current_user.media_seen(params)
        render nothing: true,
             status: :ok
      else
        response = { status: :unprocessable_entity }
        render json: response,
             status: response[:status]
      end

    end

    private

    def test_fetcher
      @test_fetcher ||= TreeService::ReadingTestFetcher.new(
        current_user
      )
    end
  end
end
