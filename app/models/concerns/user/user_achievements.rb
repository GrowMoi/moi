class User < ActiveRecord::Base
  module UserAchievements

    def assign_achievements
      new_achievements = []
      achievements = AdminAchievement.all
      my_achievements = self.my_achievements
      no_achievements = achievements.reject{ |x| my_achievements.include? x }
      achievements.each do |achievement|
        if achievement.user_win_achievement?(self)
          new_achievements << UserAdminAchievement.create!(user_id: self.id, admin_achievement_id: achievement.id)
        end
      end
      new_achievements
    end
  end
end
