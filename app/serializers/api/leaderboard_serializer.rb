module Api
  class LeaderboardSerializer < ActiveModel::Serializer
    attributes :id,
        :contents_learnt,
        :time_elapsed,
        :username,
        :email,
        :user_id,
        :user_image,
        :user_school,
        :user_city,
        :user_age,
        :user_birth_year,
        :content_summary,
        :achievements,
        :super_event_achievements_count

    def username
      object.user_username || 'unknown'
    end

    def email
      object.user_email || 'unknown'
    end

    def user_image
      object.user_image&.url
    end

    def content_summary
      if object.user
        {
          current_learnt_contents: object.user.content_learnings.count,
          total_approved_contents: Neuron.approved_public_contents.count
        }
      end
    end

    def achievements
      object.user ? object.user.my_achievements.count : 0
    end

    def super_event_achievements_count
      all_super_event_achievements_ids = scope || []
      my_achievement_ids = object.user ? object.user.my_achievements.map(&:id) : []
      user_super_event_achievement_ids = my_achievement_ids & all_super_event_achievements_ids
      user_super_event_achievement_ids.count
    end
  end
end
