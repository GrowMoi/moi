module Api
  class ContentForTestSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :possible_answers

    def possible_answers
      ActiveModel::ArraySerializer.new(
        object.possible_answers,
        each_serializer: PossibleAnswerForTestSerializer
      )
    end
  end
end
