require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  include RootNeuronMockable
  include CollectionExpectationHelpers

  include_examples "requests:current_user"

  let(:endpoint) { "/api/tree" }

  let!(:root) { create :neuron_visible_for_api }

  describe "root children" do
    let!(:a) {
      create :neuron_visible_for_api,
             parent: root
    }
    let!(:b) {
      create :neuron,
             parent: root
    }

    let(:neurons) {
      JSON.parse(response.body)
          .fetch("tree")
          .fetch("root")
          .fetch("children")
    }

    describe "root grandchildren" do
      let!(:b) {
        create :neuron_visible_for_api,
               parent: root
      }
      let!(:c) {
        create :neuron_visible_for_api,
               parent: a
      }
      let!(:d) {
        create :neuron_visible_for_api,
               parent: b
      }

      let!(:learning) {
        create :content_learning,
               user: current_user,
               content: a.contents.first
      }

      let(:params) {
        {
          username: current_user.username,
          neuronId: d.id
        }
      }

      before {
        root_neuron root
        get endpoint, params
      }

      let(:response_root) {
        JSON.parse(response.body)
            .fetch("tree")
            .fetch("root")
      }

      it "includes flags" do
        expect(response_root["in_desired_neuron_path"]).to be_truthy
        expect(response_root["children"].first["in_desired_neuron_path"]).to be_falsey
      end
    end
  end
end
