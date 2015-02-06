require "rails_helper"

describe "user management" do
  let!(:current_user) { create :user, :admin }

  before {
    login_as current_user
  }

  feature "admin sees all users", js: true do
    let!(:other_user) { create :user }

    before {
      visit admin_users_path
    }

    it {
      expect(page).to have_text(current_user.email)
      expect(page).to have_text(other_user.email)
    }
  end

  context "with forms" do
    let(:user_attrs) { attributes_for :user }
    let(:fill_form!) {
      # we need to select role
      select user_attrs.delete(:role), from: I18n.t("activerecord.attributes.user.role")
      # we fill in all other attrs
      user_attrs.each do |key, value|
        label = I18n.t("activerecord.attributes.user.#{key}")
        fill_in label, with: value
      end
    }
    #this isn't with js: true because is droping data so fails in count
    feature "create user" do
      before {
        visit new_admin_user_path
        fill_form!
        expect {
          find("input[type='submit']").click
        }.to change{ User.count }.by(1)
      }

      it {
        expect(page).to have_text(I18n.t("views.users.created"))
      }
    end

    #this is with js: true to show datatable content
    feature "create user", js: true do
      before {
        visit new_admin_user_path
        fill_form!
        find("input[type='submit']").click
      }

      it {
        expect(page).to have_text(I18n.t("views.users.created"))
        expect(page).to have_text(user_attrs[:email])
      }
    end

    feature "update user", js: true do
      let(:existing_user) { create :user }

      before {
        visit edit_admin_user_path(existing_user)
        fill_form!
        expect {
          find("input[type='submit']").click
        }.to_not change(User, :count)
      }

      it {
        expect(page).to have_text(I18n.t("views.users.updated"))
        expect(page).to have_text(user_attrs[:email])
      }
    end
  end
end
