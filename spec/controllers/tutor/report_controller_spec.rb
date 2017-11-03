require "rails_helper"

RSpec.describe Tutor::ReportController,
                type: :request do

  include_examples "neurons_controller:approved_content"

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

  before {
    login_as current_user
  }

  describe "Validate time_reading api" do

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
      expect(response).to be_success
      expect(subject["data"].count).to eq(2)
    }

    it {
      expect(subject["data"][0]["value"]).to eq(86400000)
      expect(subject["data"][1]["value"]).to eq(129600000)
    }

    it {
      expect(subject["data"][0]["user_id"]).to eq(client1[:id])
      expect(subject["data"][1]["user_id"]).to eq(client2[:id])
    }

    it {
      expect(subject["data"][0]["value_humanized"]).to eq("1 días 0 horas 0 minutos 0 segundos")
      expect(subject["data"][1]["value_humanized"]).to eq("1 días 12 horas 0 minutos 0 segundos")
    }

  end

  describe "Validate root_contents_learnt api" do

    let(:endpoint) {
      "/tutor/report/root_contents_learnt/?user_id=#{client1.id}"
    }

    let!(:user_tutor) {
      create :user_tutor,
             user: client1,
             tutor: current_user,
             status: :accepted
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
      expect(subject["data"][0]).to eq({
        "id" => b.id,
        "title" => b.title,
        "parent_id" => a.id,
        "total_contents_learnt" => 1
        })

      expect(subject["data"][1]).to eq({
        "id" => c.id,
        "title" => c.title,
        "parent_id" => a.id,
        "total_contents_learnt" => 1
        })
    }
  end
end
