RSpec.shared_context "form features" do
  let(:submit_form!) {
    find("input[type='submit']").click
  }
end
