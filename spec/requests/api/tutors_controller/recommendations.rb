require "rails_helper"

RSpec.describe Api::TutorsController,
               type: :request do
  describe "respond to recommendation requests" do

    let(:current_user) { create :user }
    let(:endpoint) {
      "/api/tutors/recommendations"
    }

    let!(:content1) {
      create :content,
             title: "content 1",
             approved: true
    }

    let!(:content2) {
      create :content,
             title: "content 2",
             approved: true
    }

    let!(:content3) {
      create :content,
             title: "content 3",
             approved: true
    }

    let!(:content4) {
      create :content,
             title: "content 4",
             approved: true
    }

    let!(:tutor_recommendation_1) {
      create :tutor_recommendation
    }

    let!(:tutor_recommendation_2) {
      create :tutor_recommendation
    }

    before {
      create :content_tutor_recommendation,
              content: content1,
              tutor_recommendation: tutor_recommendation_1
      create :content_tutor_recommendation,
              content: content2,
              tutor_recommendation: tutor_recommendation_1
      create :content_tutor_recommendation,
              content: content3,
              tutor_recommendation: tutor_recommendation_2
      create :content_tutor_recommendation,
              content: content1, #repeated
              tutor_recommendation: tutor_recommendation_2
      create :content_tutor_recommendation,
              content: content4,
              tutor_recommendation: tutor_recommendation_2
    }

    before {
      create :client_tutor_recommendation,
              client: current_user,
              tutor_recommendation: tutor_recommendation_1,
              status: :in_progress

      create :client_tutor_recommendation,
              client: current_user,
              tutor_recommendation: tutor_recommendation_2,
              status: :in_progress

      create :content_learning,
             user: current_user,
             content: content4
    }

    before { login_as current_user }

    describe "when format = 'contents'" do
      before { get endpoint, data_format: "contents" }
      subject {
        JSON.parse(response.body)
      }

      it "accepts get_recommendations request" do
        expect(response).to be_success
      end

      it "response body should have 'contents' attribute" do
        expect(subject).to include("contents")
      end

      it "contents should have size = 3, only items learnt" do
        expect(subject["contents"].size).to eq(3)
      end

      it {
        expect(subject["contents"].first).to include("id")
        expect(subject["contents"].first).to include("title")
      }

      it "meta should contain paginate options" do
        expect(subject["meta"]["total_items"]).to eq(3)
      end
    end

    describe "when format = 'recommendations'" do
      before { get endpoint, data_format: "recommendations" }
      subject {
        JSON.parse(response.body)
      }

      it "accepts request" do
        expect(response).to be_success
      end

      it "response body should have 'recommendations' attribute" do
        expect(subject).to include("recommendations")
      end

      it {
        expect(subject["recommendations"].size).to eq(2)
      }

      it {
        expect(subject["recommendations"].first).to include("id")
        expect(subject["recommendations"].first).to include("status")
        expect(subject["recommendations"].first["status"]).to eq("in_progress" || "reached")
        expect(subject["recommendations"].first).to include("tutor")
        expect(subject["recommendations"].first["tutor"]).to include("id")
        expect(subject["recommendations"].first).to include("achievement")
      }

      it "meta should contain paginate options" do
        expect(subject["meta"]["total_items"]).to eq(2)
        expect(subject["meta"]["total_in_progress"]).to eq(2)
        expect(subject["meta"]["total_reached"]).to eq(0)
      end

    end

    describe "without format" do
      before { get endpoint}
      subject {
        JSON.parse(response.body)
      }

      it {
        expect(subject).to include("recommendations")
      }

      it {
        expect(subject["recommendations"].size).to eq(2)
      }
    end

    describe "details" do
      let(:details_endpoint) {
        "/api/tutors/details"
      }
      before { get details_endpoint}
      subject {
        JSON.parse(response.body)
      }

      it {
        expect(subject).to include("details")
      }

      it {
        expect(subject["details"]["total_recommendations"]).to eq(2)
        expect(subject["details"]["recommendations_in_progress"]).to eq(2)
        expect(subject["details"]["recommendations_reached"]).to eq(0)
        expect(subject["details"]["recommendation_contents_pending"]).to eq(3)
      }
    end

  end
end
