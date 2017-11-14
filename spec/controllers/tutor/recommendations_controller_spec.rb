require "rails_helper"

RSpec.describe Tutor::RecommendationsController, type: :controller do

  let!(:current_user) {
    create :user, role: :tutor
  }

  let!(:another_user) {
    create :user, role: :tutor
  }

  let!(:client) {
    create :user, role: :cliente
  }

  before {
    create :content,
           title: "content 1",
           description: "description 1",
           approved: true
    create :content,
           title: "content 2",
           description: "description 2",
           approved: true
    create :content,
           title: "content 3",
           description: "description 3",
           approved: true
    create :content,
           title: "content 4",
           description: "description 4",
           approved: false
  }

  before {
    create :tutor_achievement,
           user: current_user,
           name: 'achievement 1'
    create :tutor_achievement,
           user: current_user,
           name: 'achievement 2'
    create :tutor_achievement,
           user: another_user ,
           name: 'achievement 3'
  }

  let!(:results) {
    Content.all
  }

  let!(:tutor_achievements) {
    TutorAchievement.where(user: current_user)
  }

  before {
    sign_in current_user
  }

  describe "contents should exists" do

    before {
      get :new
    }

    it {
      expect(subject).to render_template(:new)
    }

    it {
      expect(controller.contents.first).to be_instance_of(Content)
    }

    it {
      expect(controller.contents).not_to be_empty
    }

    it {
      expect(controller.contents.size).to eq(3) #approved only
    }

  end

  describe "Get achievements" do
    before {
      get :new
    }

    it {
      expect(controller.tutor_achievements).to eq(tutor_achievements)
    }

    it {
      expect(controller.tutor_achievements.size).to eq(2)
    }

  end

  describe "New recommendations" do
    before {
      get :new
    }

    it {
      controller.tutor_recommendation
      expect(controller.tutor_recommendation).to be_instance_of(TutorRecommendation)
    }

  end

  describe "Create recommendation" do
    subject {
      post :create
    }

    it {
      expect(subject).to render_template(:new)
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
