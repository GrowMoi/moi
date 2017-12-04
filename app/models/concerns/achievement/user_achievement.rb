class AdminAchievement < ActiveRecord::Base
  module UserAchievement

    def assign_achievement_to_user(user)
      if can_recive_achievement?(self, user)
        UserAdminAchievement.create!(user_id: user.id, admin_achievement_id: self.id)
      end
    end

    private

    def can_recive_achievement?(achievement, user)
      case achievement.number
      when 1
        user_learnt_n_content(user, achievement)
      when 2..5
        learnt_contents_in_branch(achievement, user)
      when 6
        learnt_all_contents(user)
      when 7
        learnt_a_content_in_each_public_neuron(user)
      when 8
        successful_continous_tests(achievement, user)
      when 9
        tests_given(achievement, user)
      # when 10
      #   learnt_all_contents(user)
      else
        puts "no achievement found"
      end
    end

    ##
    # user learnt n contents
    def user_learnt_n_content(user)
      number = achievement.settings['quantity']
      user.content_learnings.count >= number
    end

    ##
    # user gave 50 tests
    def tests_given(achievement, user)
      number = achievement.settings['quantity']
      user.learning_tests.count >= number
    end

    ##
    # user gave 4 tests without errors
    def successful_continous_tests(achievement, user)
      number = achievement.settings['quantity']
      user.continuous_successful_tests(number)
    end

    ##
    # user learnt all contest public/approved
    def learnt_all_contents(user)
      total_contents = Content.approved.all.count
      user.content_learnings.count == total_contents
    end

    ##
    # user learnt almost a content by public neuron
    def learnt_a_content_in_each_public_neuron(user)
      neurons = Neuron.where(is_public: true, active: true).sort_by(&:position)
      runLoop = true
      i = 0
      until runLoop == false
        neuron = public_neurons[i]
        runLoop = user.already_learnt_any?(neuron.contents)
        i += 1
      end
      runLoop
    end

    ##
    # user learnt content specific branch
    def learnt_contents_in_branch(achievement, user)
      branches = user.contents_learnt_by_branches
      name = achievement.settings['branch']
      result = find_branch(name)
      result['learnt_contents_ids'].count >= achievement.settings['quantity']
    end

    def find_branch(key, branches)
      branches.select do |branch|
        branch.title.downcase == key.downcase
      end
    end

  end
end
