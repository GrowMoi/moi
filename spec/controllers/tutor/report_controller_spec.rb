require "rails_helper"

RSpec.describe Tutor::ReportController,
                type: :request do

  subject {
    JSON.parse(response.body)
  }

  let!(:current_user) {
    create :user, role: :tutor
  }

  let!(:client1) {
    create :user, role: :cliente
  }

  let!(:client2) {
    create :user, role: :cliente
  }

  let!(:a) {
    create :neuron,
           :public,
           :with_approved_content
  }
  let!(:b) {
    create :neuron,
           :public,
           :with_approved_content,
           parent: a
  }
  let!(:c) {
    create :neuron,
           :public,
           :with_approved_content,
           parent: a
  }

  before {
    login_as current_user
  }

  describe "Validate time_reading" do

    let(:endpoint) {
      "/tutor/report/time_reading"
    }

    let!(:content_reading_time) {
      create :content_reading_time,
             user: client1,
             time: 86400000
      create :content_reading_time,
             user: client2,
             time: 129600000
    }

    let!(:users_by_tutor) {
      create :user_tutor,
             user: client1,
             tutor: current_user,
             status: :accepted
      create :user_tutor,
             user: client2,
             tutor: current_user,
             status: :accepted
    }

    before {
      get endpoint
    }

    it {
      expect(response).to have_http_status(:ok)
    }

    it {
      expect(subject["data"].count).to eq(2)
    }

    it {
      expect(subject["data"][0]).to include({
        "value" => 86400000,
        "user_id" => client1.id,
        "value_humanized" => "1 días 0 horas 0 minutos 0 segundos"
      })
      expect(subject["data"][1]).to include({
        "value" => 129600000,
        "user_id" => client2.id,
        "value_humanized" => "1 días 12 horas 0 minutos 0 segundos"
      })
    }
  end

  describe "Validate root_contents_learnt" do

    let(:endpoint) {
      "/tutor/report/root_contents_learnt/?user_id=#{client1.id}"
    }

    let!(:user_tutor) {
      create :user_tutor,
             user: client1,
             tutor: current_user,
             status: :accepted
    }

    before {
      root_neuron(a)
      create :content_learning,
             user: client1,
             content: a.contents.first
      create :content_learning,
             user: client1,
             content: b.contents.first
      create :content_learning,
             user: client1,
             content: c.contents.first
    }

    before {
      get endpoint
    }

    it {
      expect(response).to have_http_status(:ok)
    }

    it {
      expect(response).to be_success
      expect(subject["data"].count).to eq(2)
    }

    it {
      expect(subject["data"][0]).to include({
        "id" => b.id,
        "title" => b.title,
        "parent_id" => a.id,
        "total_contents_learnt" => 1
        })

      expect(subject["data"][1]).to include({
        "id" => c.id,
        "title" => c.title,
        "parent_id" => a.id,
        "total_contents_learnt" => 1
        })
    }
  end

  describe "Validate tutor_users_contents_learnt" do
    let(:endpoint) {
      "/tutor/report/tutor_users_contents_learnt"
    }

    before {
      create :content_learning,
             user: client1,
             content: a.contents.first
      create :content_learning,
             user: client1,
             content: b.contents.first
      create :content_learning,
             user: client1,
             content: c.contents.first
      create :content_learning,
             user: client2,
             content: a.contents.first
      create :content_learning,
             user: client2,
             content: b.contents.first
    }

    let!(:users_by_tutor) {
      create :user_tutor,
             user: client1,
             tutor: current_user,
             status: :accepted
      create :user_tutor,
             user: client2,
             tutor: current_user,
             status: :accepted
    }

    before {
      get endpoint
    }

    it {
      expect(response).to have_http_status(:ok)
    }

    it {
      expect(subject["data"][0]).to include({
        "user_id" => client1.id,
        "contents_learnt" => 3
      })
      expect(subject["data"][1]).to include({
        "user_id" => client2.id,
        "contents_learnt" => 2
      })
    }

  end

  describe "Validate analytics_details" do

    let!(:user_tutor) {
      create :user_tutor,
             user: client1,
             tutor: current_user,
             status: :accepted
    }

    let!(:users_by_tutor) {
      create :user_tutor,
             user: client2,
             tutor: current_user,
             status: :accepted
    }

    let!(:uri) {
      "/tutor/report/analytics_details/?user_id=#{client1.id}"
    }

    context "with one field" do
      let(:field) {
        "&fields[]=total_notes"
      }

      let(:endpoint) {
        uri.concat field
      }

      before {
        get endpoint
      }

      it {
        expect(subject["data"].count).to eq(1)
      }
    end

    context "without fields" do

      before {
        get uri
      }

      it {
        expect(subject["data"].count).to eq(0)
      }
    end

    context "with many fields" do

      let(:fields) {
        str = ''
        params = ["total_notes",
         "user_sign_in_count",
         "user_created_at",
         "user_updated_at",
         "images_opened_in_count",
         "total_neurons_learnt",
         "user_tests",
         "total_content_readings",
         "content_readings_by_branch",
         "total_right_questions",
         "used_time",
         "average_used_time_by_content"]
         params.each do |p|
            str = str.concat "&fields[]=#{p}"
        end
        str
      }

      let(:endpoint) {
        uri.concat fields
      }

      before {
        get endpoint
      }

      it {
        expect(subject["data"].count).to eq(12)
      }

      it {
        expect(subject["data"]).to include("total_notes")
        expect(subject["data"]).to include("user_sign_in_count")
        expect(subject["data"]).to include("user_created_at")
        expect(subject["data"]).to include("user_updated_at")
        expect(subject["data"]).to include("images_opened_in_count")
        expect(subject["data"]).to include("total_neurons_learnt")
        expect(subject["data"]).to include("user_tests")
        expect(subject["data"]).to include("total_content_readings")
        expect(subject["data"]).to include("content_readings_by_branch")
        expect(subject["data"]).to include("total_right_questions")
        expect(subject["data"]).to include("used_time")
        expect(subject["data"]).to include("average_used_time_by_content")
      }

      it 'validate each param...'

    end

  end
end
