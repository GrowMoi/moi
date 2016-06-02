require "rails_helper"

RSpec.describe Api::TreesController,
               type: :request do
  pending "scope is best described in neurons_controller/scope_spec"

  include_examples "requests:current_user"

  let(:endpoint) {
    "/api/tree"
  }

  let!(:root_neuron) {
    create :neuron, :visible_for_api
  }

  describe "root has right attributes" do
    let(:root) {
      JSON.parse(response.body).fetch("tree")
    }

    before { get endpoint }

    %w(
      id
      title
      children
    ).each do |field|
      it {
        binding.pry
        expect(root)
      }
    end
  end
end
