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
      @contents.map do |content|
        title = content.title
        unless @language == ApplicationController::DEFAULT_LANGUAGE
          resp = TranslatedAttribute.where(
                                            translatable_id: content.id,
                                            name: "title",
                                            language: @language
                                          ).first
          title = resp ? resp.content : title
        end
        {
          content_id: content.id,
          title: title,
          media_url: image_for(content),
          possible_answers: possible_answers_for(content)
        }
      end
    end

    def image_for(content)
      if content.media_count > 0
        content.content_medium.first.media_url
      end
    end

    def possible_answers_for(content)
      content.possible_answers.map do |possible_answer|
        text = possible_answer["text"]
        unless @language == ApplicationController::DEFAULT_LANGUAGE
          resp = TranslatedAttribute.where(
                                            translatable_type: "PossibleAnswer",
                                            translatable_id: possible_answer["id"],
                                            language: @language
                                          ).first
          text = resp ? resp.content : text
        end
        {
          id: possible_answer["id"],
          text: text,
          correct: possible_answer["correct"]
        }
      end
    end
  end
end
