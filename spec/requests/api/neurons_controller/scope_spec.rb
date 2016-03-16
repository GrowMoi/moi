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
    let(:contents) {
      body.fetch("neurons").map do |neuron|
        neuron.fetch("contents")
      end.flatten
    }

    ##
    # tree
    #       a
    #      / \
    #     b   *c
    #    /\   /\
    #   d *e f *g
    #  /\
    # h *i
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
      create :neuron, # not public
             :with_content,
             parent: a
    }
    let!(:d) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: b
    }
    let!(:e) {
      create :neuron,
             :with_approved_content,
             parent: b
    }
    let!(:f) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: c
    }
    let!(:g) {
      create :neuron,
             :with_approved_content,
             parent: c
    }
    let!(:h) {
      create :neuron,
             :public,
             :with_approved_content,
             parent: d
    }
    let!(:i) {
      create :neuron,
             :with_approved_content,
             parent: d
    }

    before {
      root_neuron(a)
    }

    context "when I haven't learnt anything" do
      before { get "/api/neurons" }

      it "includes root neuron" do
        expect_to_see(a)
      end

      it "includes root children" do
        expect_to_see(b)
      end

      it "does not include unpublished children & grandchildren" do
        expect_to_not_see(c)
        expect_to_not_see(g)
      end

      it "does not include root grandchildren" do
        expect_to_not_see(d)
      end

      it "does not include unpublished neuron's public children" do
        expect_to_not_see(f)
      end
    end

    describe "contents scope" do
      let!(:approved_content) {
        create :content,
               :approved,
               neuron: b
      }
      let!(:unapproved_content) {
        create :content,
               neuron: b
      }

      before { get "/api/neurons" }

      it "includes approved content" do
        expect_to_see(approved_content)
      end

      it "doesn't include unapproved content" do
        expect_to_not_see(unapproved_content)
      end
    end

    context "when I have learnt contents" do
      let!(:learning) {
        create :content_learning,
               user: current_user,
               content: b.contents.first
      }

      before { get "/api/neurons" }

      it "includes learnt contents' published neurons" do
        expect_to_see(a)
        expect_to_see(b)
      end

      it "doesn't include learnt unpublished neurons" do
        expect_to_not_see(e)
      end

      it "includes learnt contents' neurons published children" do
        expect_to_see(d)
      end

      it "doesn't include unlearnt neurons" do
        expect_to_not_see(h)
      end
    end

    context "when I have learnt deeper contents" do
      let!(:learnings) {
        [
          create(
            :content_learning,
            user: current_user,
            content: b.contents.first
          ),
          create(
            :content_learning,
            user: current_user,
            content: d.contents.first
          )
        ]
      }

      before { get "/api/neurons" }

      it "includes learnt content's published neurons" do
        expect_to_see(a)
        expect_to_see(b)
        expect_to_see(d)
      end

      it "doesn't include unpublished neurons" do
        expect_to_not_see(c)
        expect_to_not_see(e)
        expect_to_not_see(i)
      end

      it "includes published children" do
        expect_to_see(h)
      end
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
