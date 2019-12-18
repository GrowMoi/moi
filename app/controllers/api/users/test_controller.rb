module Api
  module Users
    class TestController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      expose(:test) {
        test = ContentLearningTest.find(params[:id])
      }

      respond_to :json

      api :GET,
          "/users/final_test/:id",
          "Get final test"
      example %q{
        // respuesta con test
        {
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
      def show
        render json: {
          id: test.id,
          questions: test.questions,
          answers: test.answers
        }
      end
    end
  end
end
