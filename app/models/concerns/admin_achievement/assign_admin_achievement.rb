class AdminAchievement < ActiveRecord::Base
  module AssignAdminAchievement

    def user_win_achievement?(user)
      case self.category
      when "content"
        by_content(self, user)
      when "branch"
        by_branch(self, user)
      when "test"
        by_test(self, user)
      when "level"
        by_level(self, user)
      when "neuron"
        by_neuron(self, user)
      else
        puts "no achievement found"
      end
    end

    private

    ##
    # user learnt n contents
    def by_content(achievement, user)
      completed = false
      settings = achievement.settings || {};

      if settings["branch"] == "any" && settings["quantity"].to_i > 0
        number = settings['quantity'].to_i
        completed = user.content_learnings.size >= number
      end

      if settings["branch"] == "all" && settings["quantity"].to_i > 0
        public_neurons = Neuron.where(is_public: true, active: true)
                                .sort_by(&:position)
        give_achievement = false
        runLoop = true
        i = 0
        until runLoop == false || i == public_neurons.count
          neuron = public_neurons[i]
          runLoop = user.already_learnt_any?(neuron.contents)
          give_achievement = runLoop
          i += 1
        end
        completed = give_achievement
      end

      #all contents learnt
      if settings["branch"] == "all" && settings["quantity"].to_i == 0
        total_contents = Neuron.approved_public_contents.count
        completed = user.content_learnings.size == total_contents
      end
      completed
    end

    ##
    # user approved n tests
    def by_test(achievement, user)
      completed = false
      settings = achievement.settings || {};
      if settings["continuous"]
        number = achievement.settings['quantity'].to_i
        completed = user.continuous_successful_tests(number)
      else
        number = achievement.settings['quantity'].to_i
        completed = user.learning_tests.size >= number
      end
      completed
    end

    ##
    # user learnt content specific branch
    def by_branch(achievement, user)
      completed = false
      name = achievement.settings['branch'] || ""
      contents = user.contents_learnt_by_branch(name)
      unless contents.blank?
        completed = contents.size >= achievement.settings['quantity'].to_i
      end
      completed
    end

    ##
    # user reach a specific level
    def by_level(achievement, user)
      user_tree = TreeService::UserTreeFetcher.new(user, nil)
      user_tree.depth.to_i == achievement.settings['level'].to_i
    end

    ##
    # user learnt content in a specific neuron
    def by_neuron(achievement, user)
      settings = achievement.settings || {};
      quantity = settings['quantity'].to_i
      neuron_id = settings['neuron_id'].to_i
      total_learnt_contents = user.content_learnings.where(neuron_id: neuron_id).count
      total_learnt_contents >= quantity
    end
  end
end
