module TreeService
  class FinalTestFetcher
    LEVEL = 9

    def initialize(user)
      @user = user
    end

    def user_final_test_for_api
      user_tree = UserTreeFetcher.new(@user, nil)
      if user_tree.depth == LEVEL
        @user_test ||= Api::LearningTestSerializer.new(
          test_creator.user_test,
          root: false
        )
      end
    end

    private

    def test_creator
      FinalTestQuestionsCreator.new(
        user: @user,
        contents: contents_for_test
      )
    end

    def contents_for_test
      Neuron.approved_public_contents.shuffle[1..21]
    end
  end
end
