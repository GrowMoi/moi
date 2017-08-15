module Api
  class AchievementSerializer < ActiveModel::Serializer
    attributes :id,
        :name,
        :description,
        :category,
        :meta

    def meta
      data = {}
      if object.category == "content"
        data["total_contents"] = Content.where(approved: :true).size
        data["learnt_contents"] = object.settings["quantity"].to_i
      end

      if object.category == "test"
        data["total_tests_ok"] = object.settings["quantity"].to_i
      end

      data
    end
  end
end
