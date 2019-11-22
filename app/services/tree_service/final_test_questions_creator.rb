module TreeService
  class FinalTestQuestionsCreator
    def initialize(options)
      @user = options.fetch :user
      @contents = options.fetch :contents
      @language = @user.preferred_lang
    end

    def user_test
      # unless @user.learning_final_tests
        @user_test ||= ContentLearningFinalTest.create!(
          user: @user,
          questions: questions
        )
      # else
        # @user.learning_final_tests
      # end
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
