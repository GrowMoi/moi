module TreeService
  class AnswerLearningTest
    attr_reader :user_test

    def initialize(options)
      @answers = options.fetch(:answers)
      @user_test = options.fetch(:user_test)
      @active_events = options.fetch(:active_events)
    end

    def process!
      user_test.update! completed: true
      self
    end

    def result
      branches_neurons_ids = TreeService::NeuronsFetcher.new(nil).neurons_ids_by_branch
      answers_result = @answers.map do |answer|
        correct_answer = correct_answer?(answer)
        if correct_answer
          learn!(answer)
          learn_content_event!(answer)
        else
          unread!(answer)
          unread_content_event!(answer)
        end
        content = Content.find(answer["content_id"])
        {
          correct: !!correct_answer,
          content_id: answer["content_id"],
          neuron_color: TreeService::NeuronsFetcher.new(content.neuron).neuron_color(branches_neurons_ids),
          user_answer: answer['answer_text']
        }
      end
      @user_test.answers = answers_result
      @user_test.save
      answers_result
    end

    private

    def learn!(answer)
      ContentLearning.create!(
        user: user_test.user,
        content_id: answer["content_id"]
      )
    end

    def learn_content_event!(answer)
      if @active_events.any?
        @active_events.map do |event|
          create_content_learning_event(event, answer["content_id"])
        end
      end
    end

    def unread!(answer)
      content_reading = ContentReading.where(
        user: user_test.user,
        content_id: answer["content_id"]
      ).first
      content_reading.destroy if content_reading
    end

    def unread_content_event!(answer)
      if @active_events.any?
        @active_events.map do |event|
          constent_reading_event = ContentReadingEvent.where(
            user_event: event,
            content_id: answer["content_id"]
          ).first
          constent_reading_event.destroy if constent_reading_event
        end
      end
    end

    def create_content_learning_event(event, content_id)
      content_reading_event = ContentReadingEvent.where(
        user_event: event,
        content_id: content_id
      ).first
      if content_reading_event
        ContentLearningEvent.create!(
          user_event: event,
          content_id: content_id
        )
      end
    end

    def correct_answer?(answer)
      answered = {}
      user_test.questions.detect do |question|
        if question["content_id"] == answer["content_id"]
          answered = question["possible_answers"].detect do |possible_answer|
            possible_answer["id"] == answer["answer_id"]
          end
        end
      end
      answered && answered["correct"]
    end
  end
end
