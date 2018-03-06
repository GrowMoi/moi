module TreeService
  class ReadingTestFetcher
    MIN_COUNT_FOR_TEST = 4

    def initialize(user)
      @user = user
    end

    def perform_test?
      if total_contents_to_be_learned >= MIN_COUNT_FOR_TEST
        contents_for_test.count >= MIN_COUNT_FOR_TEST
      else
        contents_for_test.count == total_contents_to_be_learned
      end
    end

    def user_test_for_api
      return unless perform_test?
      @user_test ||= Api::LearningTestSerializer.new(
        test_creator.user_test,
        root: false
      )
    end

    def total_contents_to_be_learned
      total_contents = Neuron.approved_public_contents.count
      user_contents = @user.content_learnings.count
      total_contents - user_contents
    end

    private

    def test_creator
      LearningTestCreator.new(
        user: @user,
        contents: test_contents
      )
    end

    def test_contents
      contents_for_test.limit(MIN_COUNT_FOR_TEST)
    end

    def contents_for_test
      ContentsForTestFetcher.new(
        @user
      ).contents
    end
  end
end
