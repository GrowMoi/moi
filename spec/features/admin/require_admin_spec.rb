require "rails_helper"

describe %Q{
  Only admin users can enter admin panel
}, type: :feature do
  context "admin" do
    let!(:user) { create :user, :admin }

    before {
      login_as user
      visit admin_root_path
    }

    it {
      expect(page).to have_http_status(:success)
    }
  end

  context "non-admin" do
    let!(:user) { create :user }

    before {
      login_as user
      visit admin_root_path
    }

    it {
      expect(current_path).to eq(root_path)
      expect(page).to have_text(
        I18n.t("views.unauthorized")
      )
    }
  end
end
