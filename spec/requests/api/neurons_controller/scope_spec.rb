require "rails_helper"

RSpec.describe Api::NeuronsController,
               type: :request do
  describe "unauthenticated #index" do
    let!(:neuron) {
      # we rely on root being present
      create :neuron
    }
    before { get "/api/neurons" }
    subject { response }
    it {
      is_expected.to have_http_status(:unauthorized)
    }
  end

  describe "neuron scope" do
    include_examples "neurons_controller:current_user"

    let(:body) {
      JSON.parse(response.body)
    }
    let(:neurons) {
      body.fetch("neurons")
    }

    let!(:tree) {

    }
    #     a
    #    / \
    #   b   c
    #  /\   /\
    # d e  f g
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
    let!(:d) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: b
    }

    before {
      root_neuron(a)
    }

    before { get "/api/neurons" }

    context "when I haven't learnt anything" do
      it "includes root neuron" do
        expect_to_see(a)
      end

      it "includes root children" do
        expect_to_see(b)
      end

      it "does not include root grandchildren" do
        expect_to_not_see(d)
      end
    end

    context "when I have learnt some contents" do
      it "includes learnt contents' published neurons" do
      end
      it "doesn't include learnt unpublished neurons" do
      end
      it "includes learnt contents' neurons published children" do
      end
    end
  end

  describe "content scope" do
    it "includes approved content" do
    end
    it "doesn't include unapproved content" do
    end
  end
end

def expect_to_see(resource)
  collection = send(resource.class.to_s.pluralize.downcase)
  expect(
    collection.detect do |n|
      n["id"] == resource.id
    end
  ).to be_present
end

def expect_to_not_see(resource)
  collection = send(resource.class.to_s.pluralize.downcase)
  expect(
    collection.detect do |n|
      n["id"] == resource.id
    end
  ).to_not be_present
end
