# == Schema Information
#
# Table name: event_achievements
#
#  id                   :integer          not null, primary key
#  user_achievement_ids :integer          default([]), is an Array
#  title                :string           not null
#  start_date           :datetime         not null
#  end_date             :datetime         not null
#  image                :string
#  message              :text
#  new_users            :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

module Api
  class EventAchievementSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :start_date,
               :end_date,
               :achievements,
               :message,
               :image

    def image
      image = object.image
      image ? image.url : ''
    end

    def achievements
      ids = object.user_achievement_ids || []
      ids.map do |id|
        achievement = AdminAchievement.find(id)
        {
          name: achievement.name,
          description: achievement.description,
          number: achievement.number
        }
      end
    end

    def start_date
      (object.start_date.to_f * 1000).to_i
    end

    def end_date
      (object.end_date.to_f * 1000).to_i
    end

    alias_method :current_user, :scope
  end
end
