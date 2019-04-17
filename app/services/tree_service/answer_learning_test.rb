module TreeService
  class AnswerLearningTest
    attr_reader :user_test

    def initialize(options)
      @answers = options.fetch(:answers)
      @user_test = options.fetch(:user_test)
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
        else
          unread!(answer)
        end
        content = Content.find(answer["content_id"])
        {
          correct: !!correct_answer,
          content_id: answer["content_id"],
          neuron_color: TreeService::NeuronsFetcher.new(content.neuron).neuron_color(branches_neurons_ids)
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

    def unread!(answer)
      content_reading = ContentReading.where(
        user: user_test.user,
        content_id: answer["content_id"]
      ).first
      content_reading.destroy if content_reading
    end

    def correct_answer?(answer)
      question = user_test.questions.detect do |question|
        question["content_id"] == answer["content_id"]
      end
      answered = question["possible_answers"].detect do |possible_answer|
        possible_answer["id"] == answer["answer_id"]
      end
      answered && answered["correct"]
    end
  end
end
