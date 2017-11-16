require "rails_helper"

RSpec.describe Tutor::RecommendationsController, type: :controller do

  let!(:current_user) {
    create :user, role: :tutor
  }

  let!(:another_user) {
    create :user, role: :tutor
  }

  let!(:client1) {
    create :user, name: "cliente1", role: :cliente
  }

  let!(:client2) {
    create :user, name: "cliente2", role: :cliente
  }

  let!(:content1) {
    create :content,
           title: "content 1",
           description: "description 1",
           approved: true
  }

  let!(:content2) {
    create :content,
           title: "content 2",
           description: "description 2",
           approved: true
  }

  let!(:content3) {
    create :content,
           title: "content 3",
           description: "description 3",
           approved: true
  }

  let!(:content4) {
    create :content,
           title: "content 4",
           description: "description 4",
           approved: false
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
  let!(:achievement3) {
    create :tutor_achievement,
           tutor: another_user ,
           name: 'achievement 3'
  }

  before {
    create :user_tutor,
      user: client1,
      tutor: current_user,
      status: :accepted
    create :user_tutor,
      user: client2,
      tutor: current_user,
      status: :accepted
  }

  let!(:results) {
    Content.all
  }

  let!(:tutor_achievements) {
    TutorAchievement.where(tutor: current_user)
  }

  let!(:tutor_recommendations) {
    TutorRecommendation.where(tutor: current_user)
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
    before {
      request.env["HTTP_REFERER"] = root_url
      post :create, :tutor_recommendation => {
        :content_tutor_recommendations => [content1.id, content2.id],
        :tutor_achievement => achievement1.id
      }
    }

    let(:my_recommendations) {
      current_user.tutor_recommendations
    }

    let(:content_for_recommendations) {
      ContentTutorRecommendation.all
    }
    let(:achievement_for_recommendation) {
      ContentTutorRecommendation.all
    }

    it {
      expect(response).to redirect_to(:back)
    }

    it {
      expect(controller.clients.size).to eq(2)
    }

    it {
      expect(controller.clients.first.user[:name]).to eq("cliente1")
    }

    it {
      expect(my_recommendations.count).to eq(1)
      expect(my_recommendations.first.tutor).to eq(current_user)
    }

    it {
      expect(content_for_recommendations.count).to eq(2)
    }

    it {
      expect(content_for_recommendations.first.tutor_recommendation).to eq(my_recommendations.first)
      expect(content_for_recommendations.first.content).to eq(content1)
    }

    it {
      expect(my_recommendations.first.tutor_achievement).to eq(achievement1)
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
