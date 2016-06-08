module Api
  class PossibleAnswerForTestSerializer < ActiveModel::Serializer
    attributes :id,
               :text
  end
end
