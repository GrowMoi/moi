class UserAchievementTest
  attr_reader :user

  def initialize(user)
    @user = user
    @test_achievement = Achievement.where(category: :test).first
  end

  def self.run!
    clients = User.where(role: :cliente)
    clients.find_each do |client|
      new(client).max_test_ok!
    end
  end

  def max_test_ok!
    learning_tests = get_learning_tests
    value = get_max_tests_ok(learning_tests)
    user_achievement = UserAchievement.new(user_id: user.id, achievement_id: @test_achievement.id)
    user_achievement.meta = {
      max_tests_ok: value
    }
    if user_achievement.save
      log "User #{@user.name} max tests ok: #{value}"
    else
      log "Failed generation of test number for User #{@user.name}"
    end
  end

  private

  def get_learning_tests
    @user.learning_tests
        .completed
        .order(updated_at: :desc)
        .map do |test|
          correct_answers = test["answers"].map {|a| a["correct"]}.uniq
          correct_answers.size == 1 && correct_answers[0] == true
        end
  end

  def get_max_tests_ok(test_results)
    count = 0
    result = []
    test_results.each_with_index  do |test_value, index|
      if test_value === true
        count = count + 1
        if index == test_results.size - 1
          result.push(count)
        end
      else
        if count > 0
          result.push(count)
        end
        count = 0
      end
    end
    result.max || 0
  end

  def log(str)
    puts str
    Rails.logger.info "[#{self.class}] #{str}"
  end

end

class CreateUserAchievements < ActiveRecord::Migration
  def up
    create_table :user_achievements do |t|
      t.references :user, index: true, null: false
      t.references :achievement, index: true, null: false
      t.json :meta
      t.timestamps null: false
    end

    say_with_time "Tests without errors by user" do
      UserAchievementTest.run!
    end
  end

  def down
    drop_table :user_achievements
  end
end
