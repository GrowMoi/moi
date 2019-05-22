
class LeaderboardAchievementGenerator

  def initialize(leader)
    @leader = leader
  end

  def self.run!
    leaders = Leaderboard.all
    leaders.find_each do |leader|
      new(leader).generate!
    end
  end

  def generate!
    client = @leader.user
    achievements_count = 0
    if client && client.my_achievements
      achievements_count = client.my_achievements.count
    end

    log "Updating db... "
    if @leader.update(achievements: achievements_count)
      log "Success: User #{client.name} has #{achievements_count} achievements"
    else
      log "Error: Failed update data for User: #{@user.name}"
    end

  end

  private

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

end

class AddAchievementToLeaderboard < ActiveRecord::Migration
  def up
    add_column :leaderboards, :achievements, :integer, default: 0

    say_with_time "Adding achievements count to Leaderboard" do
      LeaderboardAchievementGenerator.run!
    end
  end

  def down
    remove_column :leaderboards, :achievements
  end
end
