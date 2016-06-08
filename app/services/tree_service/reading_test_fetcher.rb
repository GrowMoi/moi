module TreeService
  class ReadingTestFetcher
    MIN_COUNT_FOR_TEST = 4

    def initialize(user)
      @user = user
    end

    def perform_test?
      contents_for_test.count >= MIN_COUNT_FOR_TEST
    end

    def test_contents
      return [] unless perform_test?
      ActiveModel::ArraySerializer.new(
        contents_for_test.limit(MIN_COUNT_FOR_TEST),
        root: false,
        each_serializer: Api::ContentForTestSerializer
      )
    end

    private

    def contents_for_test
      ContentsForTestFetcher.new(
        @user
      ).contents
    end
  end
end
