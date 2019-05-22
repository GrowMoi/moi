class AchievementsService
  def initialize(client, achievement)
    @client = client
    @achievement = achievement
  end

  def create_and_update_leaderboard
    achievement_saved = UserAdminAchievement.create!(user_id: @client.id, admin_achievement_id: @achievement.id)
    if achievement_saved
      leader = Leaderboard.find_by_user_id(@client.id)
      user = leader.user
      achievements_count = user.my_achievements.count

      if leader.update(achievements: achievements_count)
        puts "Leaderboard update successfully!"
      else
        puts "Error updating Leaderboard!"
      end
    end
    achievement_saved
  end

end
