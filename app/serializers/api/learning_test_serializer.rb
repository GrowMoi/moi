module Api
  class LearningTestSerializer < ActiveModel::Serializer
    attributes :id,
               :questions,
               :total_contents

    def questions
      object.questions.map do |question|
        {
          title: question["title"],
          content_id: question["content_id"],
          media_url: question["media_url"],
          possible_answers: possible_answers_for(question)
        }
      end
    end

    def possible_answers_for(question)
      question["possible_answers"].map do |possible_answer|
        possible_answer.slice("id", "text")
      end
    end

    def total_contents
      3
    end
  end
end
