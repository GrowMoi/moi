module Api
  class TreesController < BaseController
    respond_to :json

    expose(:user) {
      user = User.find_by_username(params[:username])
    }

    expose(:user_tree) {
      if user
        neuronId = params[:neuronId]
        TreeService::UserTreeFetcher.new(user, neuronId)
      end
    }

    expose(:total_approved_contents) {
      Neuron.approved_public_contents.count
    }

    api :GET,
        "/tree",
        "returns tree for current user"
    example %q{
      { "tree": { "root":
          { "id": 1,
            "title": "Neurona 1",
            "state": "florecida",
            "children": [
              { "id": 2,
                "title": "Neurona 2",
                "state": "descubierta",
                "children": [
                  { "id": 3,
                    "title": "Neurona 3",
                    "children": [] }
                ] },
              { "id": 4,
                "title": "Neurona 4",
                "state": "descubierta",
                "children": []}
            ]
          }
        },
        "meta": {
          "depth": 2,
          "depth": 2,
          "current_learnt_contents": 2,
          "total_approved_contents": 20,
          "perform_final_test": false,
          "total_final_test": 0
        }
      }
    }
    param :username, String, required: true
    param :neuronId, Integer

    def show
      if user_tree
        assign_achievement
        questions_final_test = nil
        if create_final_test?
          questions_final_test = final_test_fetcher.user_final_test_for_api
        end
        respond_with tree: { root: user_tree.root },
                     meta: { depth: user_tree.depth,
                            current_learnt_contents: user.content_learnings.count,
                            total_approved_contents: total_approved_contents,
                            final_test: questions_final_test}
      else
        render nothing: true,
                status: 404
      end
    end

    private

    def assign_achievement
      if user_tree.depth == 5
        achievement = AdminAchievement.find_by_number(10)
        my_achievements = user.user_admin_achievements.map(&:admin_achievement_id)
        has_achievements = my_achievements.include? achievement.id
        unless has_achievements
          UserAdminAchievement.create!(user_id: user.id, admin_achievement_id: achievement.id)
        end
      end
    end

    def create_final_test?
      # completed_all_contents = current_user.content_learnings.count === total_approved_contents
      achievement = AdminAchievement.find_by_number(7)
      has_achievement = UserAdminAchievement.where(user: current_user, admin_achievement: achievement).first
      create_test = false
      if !!has_achievement
        final_test = ContentLearningFinalTest.where(user: current_user, kind: "user_completed_atleast_one_public_content").last
        if !!final_test
          create_test = !(!!final_test.answers)
        else
          create_test = true
        end
      end
      !!has_achievement && create_test
    end

    def final_test_fetcher
      @final_test_fetcher ||= TreeService::FinalTestFetcher.new(
        user,
        'user_completed_atleast_one_public_content'
      )
    end
  end
end
