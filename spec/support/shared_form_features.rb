RSpec.shared_context "form features" do
  let(:submit_form!) {
    find("input[type='submit']").click
  }
  let(:select_contents_tab!) {
    # select `contents` tab:
    click_on I18n.t("activerecord.models.content").pluralize
  }
end
