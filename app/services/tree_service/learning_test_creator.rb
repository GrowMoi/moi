module TreeService
  class LearningTestCreator
    def initialize(options)
      @user = options.fetch :user
      @contents = options.fetch :contents
    end

    def user_test
      @user_test ||= ContentLearningTest.create!(
        user: @user,
        questions: questions
      )
    end

    private

    def questions
      @contents.map do |content|
        {
          content_id: content.id,
          title: title_translate(content),
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
        possible_answer_attrs(possible_answer)
      end
    end

    def possible_answer_attrs(possible_answer)
      {
        "id" => possible_answer.id,
        "correct" => possible_answer.correct,
        "text" => default_language? ? possible_answer.text : translated_possible_answer(possible_answer)
      }
    end

    def default_language?
      @user.preferred_lang == ApplicationController::DEFAULT_LANGUAGE
    end

    def translated_possible_answer(possible_answer)
       TranslateAttributeService.translate(
         possible_answer,
         :text,
         @user.preferred_lang
       ).presence || possible_answer.text
    end

    def title_translate(content)
      lang = @user.preferred_lang
      if lang == ApplicationController::DEFAULT_LANGUAGE
        content.title
      else
        resp = TranslatedAttribute.where(translatable_id: content.id,
                                  language: lang,
                                  name: 'title',
                                  translatable_type: "Content")
                                  .first
        resp ? resp.content : content.title
      end
    end
  end
end
