require "rails_helper"

feature "admin sees all users" do
  let!(:current_user) { create :user }
  let!(:other_user) { create :user }

  before {
    login_as current_user
    visit admin_users_path
  }

  it {
    expect(page).to have_text(current_user.email)
    expect(page).to have_text(other_user.email)
  }
end
