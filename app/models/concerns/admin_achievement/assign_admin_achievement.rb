class AdminAchievement < ActiveRecord::Base
  module AssignAdminAchievement

    def assign_to_user(user)
      # unless user.user_admin_achievements.map(&:admin_achievement_id).include?(self.id)
        if can_recive_achievement?(self, user)
          UserAdminAchievement.create!(user_id: user.id, admin_achievement_id: self.id)
        end
      # end
    end

    private

    def can_recive_achievement?(achievement, user)
      case achievement.number
      when 1
        user_learnt_n_content(achievement, user)
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
    def user_learnt_n_content(achievement, user)
      number = achievement.settings['quantity']
      user.content_learnings.size >= number
    end

    ##
    # user gave n tests
    def tests_given(achievement, user)
      number = achievement.settings['quantity']
      user.learning_tests.size >= number
    end

    ##
    # user gave tests without errors
    def successful_continous_tests(achievement, user)
      number = achievement.settings['quantity']
      user.continuous_successful_tests(number)
    end

    ##
    # user learnt all contest public/approved
    def learnt_all_contents(user)
      total_contents = Content.approved.all.size
      user.content_learnings.size == total_contents
    end

    ##
    # user learnt almost a content by public neuron
    def learnt_a_content_in_each_public_neuron(user)
      public_neurons = Neuron.where(is_public: true, active: true).sort_by(&:position)
      runLoop = true
      i = 0
      until runLoop == false
        neuron = public_neurons[i]
        runLoop = user.already_learnt_any?(neuron.contents)
        i += 1
        if i == public_neurons.count
          runLoop = false
        end
      end
      runLoop
    end

    ##
    # user learnt content specific branch
    def learnt_contents_in_branch(achievement, user)
      branches = user.contents_learnt_by_branches
      name = achievement.settings['branch']
      result = find_branch(name, branches)
      unless result.blank?
        result['learnt_contents_ids'].size >= achievement.settings['quantity']
      else
        false
      end
    end

    def find_branch(key, branches)
      result = branches.select do |branch|
        branch['branch'].downcase == key.downcase
      end
      result.blank? ? {} : result[0]
    end

  end
end
