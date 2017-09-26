module TreeService
  class QuizFetcher
    MIN_COUNT_FOR_TEST = 10

    def initialize(player)
      @player = player
    end

    def perform_test?
      contents_for_test.count >= MIN_COUNT_FOR_TEST
    end

    def player_test_for_api
      return unless perform_test?
      @player_test ||= Api::LearningTestSerializer.new(
        test_creator.player_test,
        root: false
      )
    end

    private

    def test_creator
      QuizQuestionsCreator.new(
        player: @player,
        contents: test_contents
      )
    end

    def test_contents
      contents_for_test.limit(MIN_COUNT_FOR_TEST)
    end

    def contents_for_test
      Content.where(approved: true).limit(13)
      # contents = Content.all.limit(10).pluck(:id)
      # Content.where(id: contents)
    end
  end
end
