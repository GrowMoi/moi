class LeaderboardGenerator

  def initialize(user)
    @user = user
  end

  def self.run!
    clients = User.where(role: :cliente)
    clients.find_each do |client|
      new(client).generate!
    end
  end

  def generate!
    leader = Leaderboard.new
    leader.user_id = @user.id
    if @user.content_learnings.empty?
      leader.contents_learnt = 0
      leader.time_elapsed = 0
    else
      user_content_learnings = ContentLearning.where(user: @user).order(created_at: :asc)
      last_content_learnt = user_content_learnings.last
      time_diff = last_content_learnt.created_at - @user.created_at
      milliseconds = (time_diff.to_f.round(3)*1000).to_i
      leader.contents_learnt = @user.learned_contents.size
      leader.time_elapsed = milliseconds
    end
    if leader.save
      log "User #{@user.name} has contents learnt: #{leader.contents_learnt}, time elapsed #{leader.time_elapsed} ms"
    else
      log "Failed save data for User: #{@user.name}"
    end
  end

  private

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

end

class CreateLeaderboard < ActiveRecord::Migration
  def up
    create_table :leaderboards do |t|
      t.references :user, index: true, null: false
      t.integer :time_elapsed, default: 0, limit: 8
      t.integer :contents_learnt, default: 0
      t.timestamps null: false
    end

    say_with_time "Generate leaders" do
      LeaderboardGenerator.run!
    end
  end

  def down
    drop_table :leaderboards
  end
end
