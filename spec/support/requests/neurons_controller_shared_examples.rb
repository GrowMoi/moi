RSpec.shared_examples "neurons_controller:current_user" do
  let(:current_user) { create :user }
  before { login_as current_user }
end

RSpec.shared_examples "neurons_controller:approved_content" do
  let(:neuron) {
    create :neuron, :public
  }
  let!(:content) {
    create :content,
           :approved,
           neuron: neuron
  }
end
