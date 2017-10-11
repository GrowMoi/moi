require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  let(:endpoint) {
    "/api/neurons/#{neuron.id}/contents/#{content.id}/reading_time"
  }

  describe "#reading_time" do
    let(:req_time) { 2.99 }
    before { login_as current_user }

    before {
      expect {
        post endpoint, time: req_time
      }.to change {
        current_user.content_reading_times.count
      }.by(1)
    }

    it {
      expect(response).to have_http_status(:created)
      expect(
        current_user.content_reading_times.first.content
      ).to eq(content)
      expect(
        current_user.content_reading_times.first.time
      ).to eq(req_time)
    }
  end
end
