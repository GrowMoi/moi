module TreeService
  class AnswerQuiz
    attr_reader :player_test

    def initialize(options)
      @answers = options.fetch(:answers)
      @player_test = options.fetch(:player_test)
    end

    def process!
      self
    end

    def result
      answers_result = @answers.map do |answer|
        correct_answer = correct_answer?(answer)
        {
          correct: !!correct_answer,
          content_id: answer["content_id"],
          question: Content.find(answer["content_id"]).title
        }
      end
      @player_test.answers = answers_result
      @player_test.save
      answers_result
    end

    private

    def correct_answer?(answer)
      question = player_test.questions.detect do |question|
        question["content_id"] == answer["content_id"]
      end
      answered = question["possible_answers"].detect do |possible_answer|
        possible_answer["id"] == answer["answer_id"]
      end
      answered && answered["correct"]
    end
  end
end
