class User < ActiveRecord::Base
  module UserStatistics

    def generate_statistics()
      statistics = {}
      statistics["total_notes"] = ContentNote.where(user_id: id).size
      statistics
    end
  end
end
