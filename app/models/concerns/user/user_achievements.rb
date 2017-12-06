class User < ActiveRecord::Base
  module UserAchievements

    def assign_achievements
      achievements = AdminAchievement.all
      no_achievements = AdminAchievement.where.not(admin_achievement_id: self.my_achievements)
      achievements.each do |achievement|
        if achievement.user_win_achievement?(self)
          UserAdminAchievement.create!(user_id: self.id, admin_achievement_id: achievement.id)
        end
      end
      self.my_achievements
    end
  end
end
