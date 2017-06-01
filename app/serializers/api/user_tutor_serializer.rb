module Api
  class UserTutorSerializer < ActiveModel::Serializer
    attributes :id, :status, :tutor

    def tutor
      object.tutor # UserSerializer.new(object.tutor)
                   # (or would be better to use custom
                   # TutorSerializer)
    end
  end
end
