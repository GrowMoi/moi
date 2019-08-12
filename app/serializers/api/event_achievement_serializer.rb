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
#  description          :string           not null
#

module Api
  class EventAchievementSerializer < ActiveModel::Serializer
    attributes :id,
               :title,
               :start_date,
               :end_date,
               :achievements,
               :message,
               :image,
               :inactive_image,
               :description,
               :taken,
               :completed

    def title
      title = get_translation("title")
    end

    def description
      description = get_translation("description")
    end

    def image
      image = object.image
      image ? image.url : ''
    end

    def inactive_image
      image = object.inactive_image
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

    def taken
      unless current_user.my_super_events.empty?
        !current_user.my_super_events.find(object.id).nil?
      else
        false
      end
    end

    def completed
      if current_user.user_event_achievements
        super_event = current_user.user_event_achievements.find_by_event_achievement_id(object.id)
        super_event ? super_event.status == "completed" : false
      else
        false
      end
    end

    alias_method :current_user, :scope

    private

    def get_translation(attribute)
      lang = current_user.preferred_lang

      unless lang == ApplicationController::DEFAULT_LANGUAGE
        resp = TranslatedAttribute.where(translatable_id: object.id, name: attribute, translatable_type:"EventAchievement").last
        return title = resp ? resp.content : object.title
      end

      return object[attribute]
    end
  end
end
