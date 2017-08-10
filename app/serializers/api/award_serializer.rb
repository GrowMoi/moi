module Api
  class AwardSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :description,
        :category,
        :settings
  end
end
