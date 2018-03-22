module Api
  module Users
    class FinalTestController < BaseController
      before_action :authenticate_user!

      respond_to :json

      expose(:user) {
        current_user
      }

      api :POST,
          "/users/final_test",
          "create a test with 21 questions"

      def create
        if user
          response = {
            status: :created,
            questions: final_test_fetcher.user_final_test_for_api,
          }
        else
          response = { status: :unprocessable_entity }
        end
        render json: response,
               status: response[:status]
      end

      private

      def final_test_fetcher
        @final_test_fetcher ||= TreeService::FinalTestFetcher.new(
          user
        )
      end
    end
  end
end
