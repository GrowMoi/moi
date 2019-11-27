module TreeService
  class QuizQuestionsCreator
    def initialize(options)
      @player = options.fetch :player
      @contents = options.fetch :contents
    end

    def player_test
      unless @player.learning_quiz
        @player_test ||= ContentLearningQuiz.create!(
          player: @player,
          questions: questions
        )
      else
        @player.learning_quiz
      end
    end

    private

    def questions
      questions = []
      @contents.each do |content|
        content.content_questions.each do |content_question|
          if content_question.possible_answers.count > 0
            questions << {
              content_id: content_question.content_id,
              title: content_question.question,
              media_url: image_for(content),
              possible_answers: possible_answers_for(content_question)
            }
          end
        end
      end
      questions
    end

    def image_for(content)
      if content.media_count > 0
        content.content_medium.first.media_url
      end
    end

    def possible_answers_for(content_question)
      content_question.possible_answers.map do |possible_answer|
        possible_answer_attrs(possible_answer)
      end
    end

    def possible_answer_attrs(possible_answer)
      {
        "id" => possible_answer.id,
        "correct" => possible_answer.correct,
        "text" => possible_answer.text
      }
    end
  end
end
