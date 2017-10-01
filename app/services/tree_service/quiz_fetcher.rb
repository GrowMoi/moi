module TreeService
  class QuizFetcher

    def initialize(player)
      @player = player
    end

    def player_test_for_api
      @player_test ||= Api::LearningTestSerializer.new(
        test_creator.player_test,
        root: false
      )
    end

    private

    def test_creator
      QuizQuestionsCreator.new(
        player: @player,
        contents: contents_for_test
      )
    end

    def contents_for_test
      content_ids = @player.quiz.level_quiz.content_ids
      Content.where(id: content_ids)
    end
  end
end
