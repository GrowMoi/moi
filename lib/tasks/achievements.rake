namespace :achievements do
  #assign achievements only for active users
  task set_user_achievements: :environment do
    clients_ids = ContentLearning.all.map(&:user_id).uniq.sort
    clients = User.where(id: clients_ids)
    achievements_db = AdminAchievement.all
    clients.each do |client|
      my_achievements = client.user_admin_achievements.map(&:admin_achievement_id)
      no_achievements = achievements_db.reject{ |x| my_achievements.include? x.id }
      assign_achievement(no_achievements, client)
    end
  end
end

def assign_achievement(achievements, user)
  achievements.each do |achievement|
    if achievement.user_win_achievement?(user)
      UserAdminAchievement.create!(user_id: user.id, admin_achievement_id: achievement.id)
      puts "user: #{user.name}, user_id: #{user.id}, achievement assign: #{achievement.name}"
    end
  end
end
