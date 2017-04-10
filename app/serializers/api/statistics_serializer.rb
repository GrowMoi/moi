module Api
  class StatisticsSerializer < ActiveModel::Serializer
    attributes  :notes_created

    def notes_created
      object["total_notes"]
    end
  end
end
