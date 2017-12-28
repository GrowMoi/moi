require "rails_helper"

RSpec.describe Tutor::DashboardController, type: :controller do

  let!(:current_user) {
    create :user, role: :tutor
  }
  let!(:achievement1) {
    create :tutor_achievement,
           tutor: current_user,
           name: 'achievement 1'
  }
  let!(:achievement2) {
    create :tutor_achievement,
           tutor: current_user,
           name: 'achievement 2'
  }
  let!(:tutor_achievements) {
    TutorAchievement.where(tutor: current_user)
  }

  before {
    sign_in current_user
  }

  describe "render index" do
    before {
      get :index
    }

    it {
      expect(response).to have_http_status(:ok)
    }
  end

  describe "Get achievements" do

    before {
      get :achievements
    }

    it {
      expect(response).to have_http_status(:ok)
    }
    it {
      expect(controller.tutor_achievements).to eq(tutor_achievements)
    }
    it {
      expect(controller.tutor_achievements.size).to eq(2)
    }

  end


  describe "Create achievements" do

    context "Ok" do

      before {
        request.env["HTTP_REFERER"] = root_url
        post :new_achievement, :tutor_achievement => {
          name: "New achievement"
        }
      }

      it {
        expect(response).to redirect_to(:back)
      }

      it {
        expect(current_user.tutor_achievements.count).to eq(3)
      }

      it {
        expect(current_user.tutor_achievements.last[:name]).to eq("New achievement")
      }
    end

    context "Empty" do
      it {
        expect {
          post :new_achievement, :tutor_achievement => {}
        }.to raise_error(ActionController::ParameterMissing)
      }
    end
  end
end
