require "rails_helper"

RSpec.describe Api::ContentsController,
               type: :request do
  include_examples "neurons_controller:approved_content"

  let(:current_user) { create :user }

  let(:endpoint) {
    "/api/neurons/#{neuron.id}/contents/#{content.id}/read"
  }

  let(:json_response) {
    JSON.parse response.body
  }

  before { login_as current_user }

  describe "#read not triggering test" do
    before { post endpoint }

    it {
      expect(json_response["perform_test"]).to be_falsey
    }
    it {
      expect(json_response["test_contents"]).to be_empty
    }
  end

  describe "triggering test #read" do
    let(:legacy_readings_count) {
      TreeService::ReadingTestFetcher::MIN_COUNT_FOR_TEST - 1
    }

    let!(:already_read_contents) {
      legacy_readings_count.times.map do
        create :content,
               :approved,
               :with_possible_answers,
               neuron: neuron
      end
    }

    let!(:legacy_readings) {
      already_read_contents.map do |content|
        create :content_reading,
               content: content,
               user: current_user
      end
    }

    before { post endpoint }

    it {
      expect(json_response["perform_test"]).to be_truthy
    }

    it {
      %w(
        id
        title
        possible_answers
      ).each do |key|
        expect(
          json_response["test_contents"].first
        ).to have_key(key)
      end
    }
  end
end
